extends Node
class_name ConnectionManager

@export var master_spy: SpyInstance
@export var tower: TowerInstance
@export var test_spy: SpyInstance
@onready var connection_lines = $"../Connections"

var nodes: Array = []
# {[start_spy, end_spy]: value}
var connections: Dictionary = {}

signal new_connection_established(start_spy, end_spy, value)
signal connection_lost(start_spy, end_spy, value)

signal connection_highlighted(connection_line)
signal connection_unhighlighted(connection_line)

signal exposing_succeeded(target_spy)

func get_towers():
	return get_tree().get_nodes_in_group("Towers")

func get_spys():
	return get_tree().get_nodes_in_group("Spys")

func update_nodes():
	var towers = get_towers()
	var spys = get_spys()
	nodes = towers + spys

func add_connection(start_spy, end_spy, value = 1):
	if (
		connections.keys().has([start_spy, end_spy])
		or connections.keys().has([end_spy, start_spy])
	):
		return

	if not start_spy in nodes:
		nodes.append(start_spy)
	if not end_spy in nodes:
		nodes.append(end_spy)

	start_spy.connections[end_spy] = value
	end_spy.connections[start_spy] = value

	connections.set([start_spy, end_spy], value)

func remove_connection_from_spy(spy):
	for nodes_pair in connections.keys():
		if nodes_pair.has(spy):
			connections.erase(nodes_pair)

func get_all_connections_from_spy(spy):
	return connections.keys().filter(func(pair): return pair.has(spy))

func match_connection_nodes(connection, start_spy, end_spy):
	return connection.nodes == [start_spy, end_spy] or connection.nodes == [end_spy, start_spy]

func has_connection(start_spy, end_spy):
	return connections.has([start_spy, end_spy]) or connections.has([end_spy, start_spy])

func get_connection_instance(start_spy, end_spy):
	for connection in connection_lines.get_children():
		if match_connection_nodes(connection, start_spy, end_spy):
			return connection

func get_connection_value(start_spy, end_spy):
	return max(
		connections.get([start_spy, end_spy], 0),
		connections.get([end_spy, start_spy], 0)
		)

func get_reachable_nodes(start_spy, visited_nodes = [], reachable_nodes = []):
	if not reachable_nodes.has(start_spy):
		reachable_nodes.append(start_spy)

	var neighbor_nodes = start_spy.connections.keys()
	var are_all_neighbor_nodes_in_visited_nodes = neighbor_nodes.all(visited_nodes.has)

	if are_all_neighbor_nodes_in_visited_nodes or not start_spy.connections:
		return reachable_nodes

	visited_nodes.append(start_spy)

	for neighbor in neighbor_nodes:
		if not visited_nodes.has(neighbor):
			get_reachable_nodes(neighbor, visited_nodes, reachable_nodes)

	return reachable_nodes

func get_shortest_paths_from_node(start_spy):
	var all_nodes = nodes.duplicate()

	var paths = {}
	for node in all_nodes:
		paths[node] = {
			"distance": INF,
			"previous": null,
			"paths": [],
			"path_nodes": [node]
		}

	paths[start_spy]["distance"] = 0

	# get reachable nodes
	var reachable_nodes = get_reachable_nodes(start_spy)
	# start searching
	while reachable_nodes.size() > 0:
		var current_node = null
		# find the nearest node
		for node in reachable_nodes:
			if current_node == null or paths[node]["distance"] < paths[current_node]["distance"]:
				current_node = node

		reachable_nodes.erase(current_node)
		var neighbor_nodes = current_node.connections.keys()
		for neighbor_node in neighbor_nodes:
			var value = current_node.connections[neighbor_node]
			var new_distance = paths[current_node]["distance"] + value
			# 塔不能作为路径的途径点
			if current_node is TowerInstance:
				continue

			if new_distance < paths[neighbor_node]["distance"]:
				paths[neighbor_node]["distance"] = new_distance
				paths[neighbor_node]["previous"] = current_node

				var new_path_nodes_to_neighbor = paths[current_node]["path_nodes"].duplicate()

				new_path_nodes_to_neighbor.append(neighbor_node)
				paths[neighbor_node]["path_nodes"] = new_path_nodes_to_neighbor

				for index in range(paths[neighbor_node]["path_nodes"].size() - 1):
					var connection_start_spy = paths[neighbor_node]["path_nodes"][index]
					var connection_end_spy = paths[neighbor_node]["path_nodes"][index + 1]

					var connection = get_connection_instance(
						connection_start_spy,
						connection_end_spy
					)
					paths[neighbor_node]["paths"].append(connection)
	return paths

func get_shortest_path_to_node(start_spy, end_spy):
	return get_shortest_paths_from_node(start_spy)[end_spy]["paths"]

func get_nodes_in_distance(source_spy, distance = 2):
	var all_nodes = nodes.duplicate()
	var paths = get_shortest_paths_from_node(source_spy)
	var nodes_in_distance = []
	for node in all_nodes:
		if paths[node]["distance"] <= distance and paths[node]["distance"] != 0:
			nodes_in_distance.append(node)

	return nodes_in_distance

func get_near_connections(source_spy, distance = 2):
	var all_nodes = nodes.duplicate()
	var paths = get_shortest_paths_from_node(source_spy)
	var near_connections = []

	for node in all_nodes:
		if paths[node]["distance"] <= distance and paths[node]["distance"] != 0:
			var connections_to_node = paths[node]["paths"]
			near_connections.append_array(
				connections_to_node.filter(
					func(connection): return (
						connection not in near_connections
						and connection != null
					)
				)
			)

	return near_connections


func highlight_near_connections(source_spy, distance = 2):
	var near_connections = get_near_connections(source_spy, distance)
	for connection_line in near_connections:
		if connection_line.highlighted:
			continue
		connection_line.highlighted = true
		connection_line.highlight()

func unhighlight_all_connections():
	for connection_line in connection_lines.get_children():
		if connection_line.highlighted:
			connection_line.highlighted = false
			connection_line.unhighlight()
			emit_signal("connection_unhighlighted", connection_line)

func is_connect_to_node(source_spy, target_spy):
	var is_connect = get_shortest_path_to_node(source_spy, target_spy).size() > 0
	return is_connect

func is_inside_path_to_tower(source_spy):
	var path_to_tower = get_shortest_path_to_node(source_spy, tower)
	var path_to_master_spy = get_shortest_path_to_node(source_spy, master_spy)
	var is_inside = (
		path_to_tower.size() > 0
		and path_to_master_spy.size() > 0
		and path_to_tower.all(func(node): return node not in path_to_master_spy))

	# if is_inside:
	# 	print("Spy ", source_spy.code_name, " is inside path to tower.")

	return is_inside
## signals
func update_reachable_status():
	var reachable_nodes = get_reachable_nodes(master_spy)
	for node in nodes:
		if node in reachable_nodes:
			node.node_status["reachable"] = true
		else:
			node.node_status["reachable"] = false

func connect_connection_signals(spy_instances: Array) -> void:
	for spy in spy_instances:
		spy.connect("building_connection_started", _on_spy_node_building_connection_started)
		spy.connect("building_connection_ended", _on_spy_node_building_connection_ended)

func _ready() -> void:
	update_nodes()
	connect_connection_signals(nodes)

	GameStore.ConnectingStore.initialize_tower_reachability(get_towers())


var connecting_start_node: Node2D = null
var connecting_end_node: Node2D = null

func _on_spy_node_building_connection_ended(end_node) -> void:
	# print("New connection established between: ", connecting_start_node, " and ", connecting_end_node, " with value: ", 1)
	connecting_end_node = end_node
	if (connecting_start_node == connecting_end_node
	or has_connection(connecting_start_node, connecting_end_node)
	or not connecting_start_node
	or (not connecting_start_node.node_status.is_employed and not connecting_end_node.node_status.is_employed)):
		return

	add_connection(connecting_start_node, connecting_end_node)

	emit_signal_and_clear_connecting_nodes()

func _on_spy_node_building_connection_started(start_node) -> void:
	# print("Building connection started between: ", start_node)
	connecting_start_node = start_node

func emit_signal_and_clear_connecting_nodes() -> void:
	emit_signal("new_connection_established", connecting_start_node, connecting_end_node, 1)
	connecting_start_node = null
	connecting_end_node = null


	# for test
	# if connections.size() > 3:
	# 	print_debug(get_shortest_paths_from_node(master_spy))

func _on_signal_center_spy_manager_deleted(spy: Variant) -> void:
	spy.connections = {}
	var all_connections = get_all_connections_from_spy(spy)
	for connection_node_pair in all_connections:
		var target_spy = connection_node_pair.filter(
			func(node): return not node == spy
			)[0]
		var value = connections[connection_node_pair]
		emit_signal("connection_lost", spy, target_spy, value)

	remove_connection_from_spy(spy)
	for connection in connection_lines.get_children():
		if connection.nodes.has(spy):
			connection.queue_free()
			# connection_lines.remove_child(connection)
			# connection.free()
	update_reachable_status()
	for other_node in nodes:
		if (
			other_node.working_state_machine.has_initialized
			and not other_node.node_status["reachable"]
			and not other_node.working_state_machine.is_state("Captured")
			):
			other_node.working_state_machine.node_switch_to("Unreachable")

# func _on_signal_center_enemy_patrol_captured(spy: Variant, _enemy: Variant) -> void:
	# spy.connections = {}
	# var all_connections = get_all_connections_from_spy(spy)
	# for connection_node_pair in all_connections:
	# 	var target_spy = connection_node_pair.filter(
	# 		func(node): return not node == spy
	# 		)[0]
	# 	var value = connections[connection_node_pair]
	# 	emit_signal("connection_lost", spy, target_spy, value)

	# remove_connection_from_spy(spy)
	# for connection in connection_lines.get_children():
	# 	if connection.nodes.has(spy):
	# 		connection.queue_free()
	# 		# connection_lines.remove_child(connection)
	# 		# connection.free()
	# update_reachable_status()
	# for other_node in nodes:
	# 	if (
	# 		other_node.working_state_machine.has_initialized
	# 		and not other_node.node_status["reachable"]
	# 		and not other_node.working_state_machine.is_state("Captured")
	# 		):
	# 		other_node.working_state_machine.node_switch_to("Unreachable")

	# pass # Replace with function body.

func _on_signal_center_connection_changed() -> void:
	for node in nodes:
		update_reachable_status()
		if node is TowerInstance:
			GameStore.ConnectingStore.tower_reachability[node] = is_connect_to_node(master_spy, node)
			continue

		node.is_inside_path_to_tower = is_inside_path_to_tower(node)

func _on_signal_center_click_spy(spy: Variant) -> void:
	unhighlight_all_connections()
	highlight_near_connections(spy)

func _on_signal_center_exposing_started(spy: Variant) -> void:
	var near_nodes = get_nodes_in_distance(spy, 2).filter(func(node):
		if node is TowerInstance:
			return false
		return (
			node is SpyInstance
			and not node.captured_state_machine.is_state("Locked")
			and not node.working_state_machine.is_state("Captured")
			and not node == spy
		))

	if not near_nodes:
		return

	var target_spy = near_nodes[randi() % near_nodes.size()]
	emit_signal("exposing_succeeded", target_spy)
