extends Node2D
class_name TowerInstance

@onready var connection_lines = $ConnectionLines

@onready var working_state_machine = $WorkingStateMachine

var connection_start_from: Node2D

var connections: Dictionary

var node_status = {
	"is_connecting": false,
	"has_connection": false,
	"in_section": null,
	"reachable": false,
}

signal building_connection_started
signal building_connection_ended

func _init():
	pass

func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if not working_state_machine.get_state_name() in ["Hovering", "Connecting"]:
			return

		if not node_status.is_connecting:
			node_status.is_connecting = true
			working_state_machine.node_switch_to("Connecting")
			emit_signal("building_connection_started", self)
			# print("Building connection started between: ", self)

		var mouse_position = get_global_mouse_position()
		# var local_position = get_global_mouse_position()

		if ConnectionUtils.has_preview_line(connection_lines):
			var preview_line = ConnectionUtils.get_preview_line(connection_lines)
			preview_line.points[1] = mouse_position

		else:
			var preview_line = ConnectionLine.new()
			preview_line.add_to_group("preview_line")

			preview_line.points = [global_position, mouse_position]
			connection_lines.add_child(preview_line)

	# release mouse button
	else:
		if node_status.is_connecting:
			node_status.is_connecting = false
			working_state_machine.node_switch_to_last_stable_state()

			# emit_signal("building_connection_abandoned")
		if working_state_machine.is_state("Selected"):
			working_state_machine.node_switch_to_last_stable_state()
			emit_signal("building_connection_ended", self)
			# print("Building connection ended between: ", self)
		ConnectionUtils.clear_preview_line(connection_lines)


class ConnectionUtils:
	static func get_preview_line(current_connection):
		var children = current_connection.get_children()
		var preview_lines = children.filter(func(node): return node.is_in_group("preview_line"))

		return preview_lines[0] if preview_lines.size() > 0 else null

	static func has_preview_line(current_connection):
		return ConnectionUtils.get_preview_line(current_connection) != null

	static func clear_preview_line(current_connection):
		if ConnectionUtils.has_preview_line(current_connection):
			var preview_line = ConnectionUtils.get_preview_line(current_connection)
			preview_line.queue_free()
