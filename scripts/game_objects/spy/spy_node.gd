extends Area2D

@onready var working_state_machine = get_node('../WorkingStateMachine')


var hover_period: float = 0.1
var since_hover: float = 0.0

signal click_spy

func _ready() -> void:
	pass

func _process(delta) -> void:
	var mouse_position = get_global_mouse_position()
	if mouse_position.distance_to(global_position) < 16:
		mouse_input(delta)

func mouse_input(delta = 0):
	if not working_state_machine.current_state_name in ["Idle", "Unreachable"]:
		return
	# TODO: check game_store is connecting
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		working_state_machine.node_switch_to("Selected")
		return

	if Input.is_action_just_pressed("MouseClick"):
		working_state_machine.node_switch_to("Selected")
		return
	if Input.is_action_just_released("MouseClick"):
		if working_state_machine.last_stable_state_name == "Unreachable" or not GameStore.ConnectingStore.is_connecting:
			return
	since_hover += delta
	if since_hover > hover_period:
		emit_signal("click_spy", get_parent())
		working_state_machine.node_switch_to("Hovering")
		since_hover = 0.0

func _on_mouse_entered() -> void:
	mouse_input()
	# print("mouse entered@")

func _on_mouse_exited() -> void:
	# print("mouse exited@")
	if working_state_machine.get_state_name() in ["Hovering", "Selected"]:
		working_state_machine.node_switch_to_last_stable_state()
