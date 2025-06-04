extends Area2D

@onready var state_machine = get_node('../StateMachine')

signal mouse_still_inside

func _ready() -> void:
	connect("mouse_still_inside", _on_mouse_still_inside)

func _process(_delta) -> void:
	var mouse_position = get_global_mouse_position()
	if mouse_position.distance_to(global_position) < 16:
		emit_signal("mouse_still_inside")

func hover_handler():
	if not state_machine.current_state_name in ["Idle", "Unreachable"]:
		return
	# TODO: check game_store is connecting
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		state_machine.spy_switch_to("Selected")
	else:
		if state_machine.last_stable_state_name == "Unreachable":
			return
		state_machine.spy_switch_to("Hovering")

func _on_mouse_still_inside() -> void:
	hover_handler()

func _on_mouse_entered() -> void:
	hover_handler()

func _on_mouse_exited() -> void:
	if state_machine.get_state_name() in ["Hovering", "Selected"]:
		state_machine.spy_switch_to_last_stable_state()
