extends Node

@onready var spys = get_tree().get_nodes_in_group("Spys")

func _ready() -> void:
	for spy in spys:
		var state_machine = spy.get_node("StateMachine")
		state_machine.spy_switch_to("Invisible")
		if spy.is_in_group("MasterSpys") and state_machine.is_state("Invisible"):
			state_machine.spy_switch_to("Initializing")

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
		spy.get_node("StateMachine").spy_switch_to("Unreachable")
		spy.add_to_group("VisibleSpys")
		spy.remove_from_group("InvisibleSpys")

func _on_signal_center_connection_established(start_node:Variant, end_node:Variant, _value) -> void:
	employ_spy(start_node)
	employ_spy(end_node)


func employ_spy(spy):
	print("Employing spy: ", spy.name)
	var state_machine = spy.get_node("StateMachine")
	if state_machine.is_state("Unreachable") and spy.connections:
		state_machine.spy_switch_to("Initializing")


