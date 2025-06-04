extends Node

@onready var spys = get_tree().get_nodes_in_group("Spys")
@onready var connection_manager = get_node("../ConnectionManager")

func _ready() -> void:
	for spy in spys:
		var working_state_machine = spy.get_node("WorkingStateMachine")
		working_state_machine.spy_switch_to("Invisible")
		if spy.is_in_group("MasterSpys") and working_state_machine.is_state("Invisible"):
			working_state_machine.spy_switch_to("Initializing")

func _process(_delta: float) -> void:
	# for spy in spys:
	# 	var state_machine = spy.get_node("StateMachine")
	# 	if spy.is_in_group("VisibleSpys") and state_machine.is_state("Invisible"):
	# 		state_machine.spy_switch_to("Initializing")
	pass

func _on_signal_center_spy_manager_discovered(_source_spy, target_spy) -> void:
	show_spy(target_spy)

func show_spy(spy):
	# print(spy.spy_status.in_section)
	if spy.is_in_group("InvisibleSpys") and spy.spy_status.in_section:
		spy.get_node("WorkingStateMachine").spy_switch_to("Unreachable")
		spy.add_to_group("VisibleSpys")
		spy.remove_from_group("InvisibleSpys")

func _on_signal_center_connection_established(start_node: Variant, end_node: Variant, _value) -> void:
	connection_manager.update_reachable_status()
	employ_spy(start_node)
	employ_spy(end_node)

	for spy in spys:
		if spy.spy_status["reachable"]:
			employ_spy(spy)


func employ_spy(spy):
	print("Employing spy: ", spy.name)
	var working_state_machine = spy.get_node("WorkingStateMachine")
	if working_state_machine.is_state("Unreachable"):
		if working_state_machine.has_initialized:
			working_state_machine.spy_switch_to("Idle")

		elif spy.connections:
			working_state_machine.spy_switch_to("Initializing")
