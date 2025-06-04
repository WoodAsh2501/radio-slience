class_name SpyCapturedStateMachine
extends StateMachine

@onready var spy_instance = $"../"
@onready var captured_mark = $"../CapturedMark"

func mark_as_captured():
	captured_mark.visible = true
	spy_instance.add_to_group("LockedSpys")

func mark_as_not_captured():
	captured_mark.visible = false
	spy_instance.remove_from_group("LockedSpys")

func _on_signal_center_enemy_patrol_detected(spy, _enemy):
	if spy == spy_instance:
		print("Spy Captured State Machine: Spy Detected by Enemy")
		switch_to("Locked")

func _on_signal_center_enemy_patrol_captured(spy, _enemy):
	if spy == spy_instance:
		switch_to("Default")
