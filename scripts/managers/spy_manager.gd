extends Node

@onready var spys = get_tree().get_nodes_in_group("Spys")
@onready var connection_manager = get_node("../ConnectionManager")

signal employ_new_spy

var dev_show_all_spys: bool = false

func _ready() -> void:
	for spy in spys:
		var working_state_machine = spy.get_node("WorkingStateMachine")
		working_state_machine.node_switch_to("Invisible")
		if spy.is_in_group("MasterSpys") and working_state_machine.is_state("Invisible"):
			working_state_machine.node_switch_to("Initializing")

func _process(_delta: float) -> void:
	for spy in spys:
		if spy.node_status["is_employed"] or spy.is_in_group("VisibleSpys"):
			continue

		spy.visible = dev_show_all_spys
	# for spy in spys:
	# 	var state_machine = spy.get_node("StateMachine")
	# 	if spy.is_in_group("VisibleSpys") and state_machine.is_state("Invisible"):
	# 		state_machine.node_switch_to("Initializing")
	pass

func _on_signal_center_spy_manager_discovered(_source_spy, target_spy) -> void:
	show_spy(target_spy)

func show_spy(spy):
	# print(spy.node_status.in_section)
	# if spy.is_in_group("InvisibleSpys") and spy.node_status.in_section:
	if spy.is_in_group("InvisibleSpys"):
		spy.get_node("WorkingStateMachine").node_switch_to("Unreachable")
		spy.add_to_group("VisibleSpys")
		spy.remove_from_group("InvisibleSpys")

func _on_signal_center_connection_established(start_node: Variant, end_node: Variant, _value) -> void:
	connection_manager.update_reachable_status()
	employ_spy(start_node)
	employ_spy(end_node)

	for spy in spys:
		if spy.node_status["reachable"]:
			employ_spy(spy)


func employ_spy(spy):
	# print("Employing spy: ", spy.name)
	emit_signal("employ_new_spy", spy)
	var working_state_machine = spy.get_node("WorkingStateMachine")
	if working_state_machine.is_state("Unreachable"):
		if working_state_machine.has_initialized:
			working_state_machine.node_switch_to("Idle")

		elif spy.connections:
			working_state_machine.node_switch_to("Initializing")

	spy.node_status["is_employed"] = true
