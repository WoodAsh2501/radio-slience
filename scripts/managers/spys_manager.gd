extends Node

func _process(_delta: float) -> void:
	var spys = get_tree().get_nodes_in_group("Spys")
	for spy in spys:
		var state_machine = spy.get_node("StateMachine")
		if spy.is_in_group("VisibleSpys") and state_machine.is_state("Invisible"):
			state_machine.switch_to("Initializing")


func _on_signal_center_spy_manager_discovered(_source_spy, target_spy) -> void:
	if target_spy.is_in_group("InvisibleSpys"):
		target_spy.get_node("StateMachine").switch_to("Initializing")
		target_spy.add_to_group("VisibleSpys")
		target_spy.remove_from_group("InvisibleSpys")