extends Node
class_name ConnectionManager

@export var master_spy: SpyInstance
@onready var connections_instance = $"../Connections"

var spys: Array = []
var connections: Dictionary = {}

signal new_connection_established(start_spy, end_spy, value)

func update_spys():
	spys = get_tree().get_nodes_in_group("Spys")

func add_connection(start_spy, end_spy, value = 1):
	if (
		connections.keys().has([start_spy, end_spy])
		or connections.keys().has([end_spy, start_spy])
	):
		return

	if not start_spy in spys:
		spys.append(start_spy)
	if not end_spy in spys:
		spys.append(end_spy)

	start_spy.connections[end_spy] = value
	end_spy.connections[start_spy] = value

	connections.set([start_spy, end_spy], value)

func match_connection_nodes(connection, start_spy, end_spy):
	return connection.nodes == [start_spy, end_spy] or connection.nodes == [end_spy, start_spy]

func get_connection_instance(start_spy, end_spy):
	for connection in connections_instance.get_children():
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
	var all_nodes = spys.duplicate()

	var paths = {}
	for node in all_nodes:
		paths[node] = {
			"distance": INF,
			"previous": null,
			"paths": [],
			"path_nodes": []
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
	return get_shortest_paths_from_node(start_spy)[end_spy]["path"]

## signals

func connect_connection_signals(spy_instances: Array) -> void:
	for spy in spy_instances:
		spy.connect("building_connection_started", _on_spy_node_building_connection_started)
		spy.connect("building_connection_ended", _on_spy_node_building_connection_ended)

func _ready() -> void:
	update_spys()
	connect_connection_signals(spys)

var connecting_start_node: Node2D = null
var connecting_end_node: Node2D = null

func _on_spy_node_building_connection_ended(end_node) -> void:
	# print("New connection established between: ", connecting_start_node, " and ", connecting_end_node, " with value: ", 1)
	connecting_end_node = end_node
	if connecting_start_node == connecting_end_node:
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
	if connections.size() > 3:
		print_debug(get_shortest_paths_from_node(master_spy))
