extends Node

func _on_signal_center_connection_established(start_node:Variant, end_node:Variant, value:float) -> void:
	var new_connection = ConnectionLine.new()
	new_connection.points = [start_node.global_position, end_node.global_position]
	new_connection.value = value
	new_connection.nodes = [start_node, end_node]
	add_child(new_connection)
	new_connection.add_to_group("Connections")
