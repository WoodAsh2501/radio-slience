extends Node2D

@onready var connections = $Connections
@onready var state_machine = $StateMachine
@onready var enemy_detect_range = $EnemyDetectRange

var is_connecting = false
var connection_start_from: Node2D

signal building_connection_started
signal building_connection_ended

signal radio_range_enemy_entered
signal radio_range_enemy_exited

func _init():
	pass

func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if not state_machine.get_state_name() in ["Hovering", "Connecting"]:
			return

		if not is_connecting:
			is_connecting = true
			state_machine.switch_to("Connecting")
			emit_signal("building_connection_started", self)

		var mouse_position = get_global_mouse_position()
		# var local_position = get_global_mouse_position()

		if ConnectionUtils.has_preview_line(connections):
			var preview_line = ConnectionUtils.get_preview_line(connections)
			preview_line.points[1] = mouse_position

		else:
			var preview_line = ConnectionLine.new()
			preview_line.add_to_group("preview_line")
			
			preview_line.points = [global_position, mouse_position]
			connections.add_child(preview_line)

	else:
		if is_connecting:
			is_connecting = false
			state_machine.switch_to("Default")
			
			# emit_signal("building_connection_abandoned")
		if state_machine.is_state("Selected"):
			# print("Connected!")
			state_machine.switch_to("Default")
			emit_signal("building_connection_ended", self)
		ConnectionUtils.clear_preview_line(connections)


func _on_enemy_detect_range_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Enemies")):
		enemy_detect_range.visible = true
		radio_range_enemy_entered.emit(self, body)

func _on_enemy_detect_range_body_exited(body: Node2D) -> void:
	if (body.is_in_group("Enemies")):
		enemy_detect_range.visible = false
		radio_range_enemy_exited.emit(self, body)

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
