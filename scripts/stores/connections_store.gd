extends Node

@onready var spy_instances = get_tree().get_nodes_in_group("Spys")

signal connecting_complete

func _ready() -> void:
	for spy_instance in spy_instances:
		spy_instance.connect("building_connection_started", _on_spy_node_building_connection_started)
		spy_instance.connect("building_connection_ended", _on_spy_node_building_connection_ended)

var connections: Array = []
var connecting_start_node: Node2D = null
var connecting_end_node: Node2D = null

func _on_spy_node_building_connection_ended(end_node) -> void:
	connecting_end_node = end_node
	if connecting_start_node == connecting_end_node:
		return

	var new_connection = [connecting_start_node, connecting_end_node]
	if (
		connections.has(new_connection)
		or connections.has(Utils.reversed(new_connection))
	):
		return

	print(new_connection)
	connections.append(new_connection)

	var newLine = ConnectionLine.new()
	newLine.points = [connecting_start_node.global_position, connecting_end_node.global_position]
	newLine.add_to_group("connection")
	add_child(newLine)

	emit_signal("connecting_complete", connecting_start_node, connecting_end_node)

func _on_spy_node_building_connection_started(start_node) -> void:
	# print("Connection started from: ", start_node)
	connecting_start_node = start_node
