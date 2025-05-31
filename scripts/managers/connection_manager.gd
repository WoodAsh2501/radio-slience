extends Node
class_name ConnectionManager

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
