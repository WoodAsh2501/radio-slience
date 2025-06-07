extends Node2D
class_name SpyInstance

@onready var connection_lines = $ConnectionLines
@onready var enemy_detect_range = $EnemyDetectRange

@onready var working_state_machine = $WorkingStateMachine
@onready var caputured_state_machine = $CapturedStateMachine
@onready var clue_button = $ClueButton
@export var code_name: String = "Spy"

var spy_data: Dictionary = {}

var is_discovered = false
var is_collected = false


var connection_start_from: Node2D
var connections: Dictionary
var node_status = {
	"is_employed": false,
	"is_connecting": false,
	"has_connection": false,
	"in_section": null,
	"reachable": false,
	"is_investigated": false
}

signal building_connection_started
signal building_connection_ended

signal radio_range_enemy_entered
signal radio_range_enemy_exited

signal connect_range_spy_entered
signal connect_range_spy_exited

signal collect_clue

func _ready() -> void:
	clue_button.visible = false

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


func _on_enemy_detect_range_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Enemies")):
		enemy_detect_range.visible = true
		radio_range_enemy_entered.emit(self, body)

func _on_enemy_detect_range_body_exited(body: Node2D) -> void:
	if (body.is_in_group("Enemies")):
		enemy_detect_range.visible = false
		radio_range_enemy_exited.emit(self, body)

func _on_spy_detect_range_area_entered(area: Area2D) -> void:
	if area.name in ["SpyDetectRange", "EnemyDetectRange"]:
		return
	var parent_instance = area.get_parent()
	if (
		(parent_instance.is_in_group("InvisibleSpys")) and area.name == "SpyNode"
	) or area.name == "TowerNode":
		connect_range_spy_entered.emit(self, parent_instance)

func _on_spy_detect_range_area_exited(_area: Area2D) -> void:
	# var parent_instance = area.get_parent().get_parent()
	# print("Spy detect range area exited: ", parent_instance.name)
	# if (parent_instance.is_in_group("Spys")):
	# 	connect_range_spy_exited.emit(self, parent_instance)
	pass

func discover_clue(data):
	clue_button.visible = true
	clue_button.spy_data = data
	# print(clue_button.spy_data)

func _on_clue_button_pressed() -> void:
	clue_button.visible = false
	# print(clue_button.spy_data)
	emit_signal("collect_clue", clue_button.spy_data)
	clue_button.spy_data = null

func _on_signal_center_clue_discovered(data):
	if data["codeName"] == code_name:
		is_discovered = true

func _on_signal_center_clue_collected(data):
	if data["codeName"] == code_name:
		is_collected = true
		print("Spy clue collected: ", code_name)

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
