extends Area2D

@onready var state_machine = get_node('../StateMachine')

func _on_mouse_entered() -> void:
	if not state_machine.is_state("Idle"):
		return
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		state_machine.spy_switch_to("Selected")
	else:
		state_machine.spy_switch_to("Hovering")

func _on_mouse_exited() -> void:
	if state_machine.get_state_name() in ["Hovering", "Selected"]:
		state_machine.spy_switch_to("Idle")
