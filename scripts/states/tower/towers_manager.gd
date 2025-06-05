extends Node

@onready var towers = get_tree().get_nodes_in_group("Towers")
@onready var connection_manager = get_node("../ConnectionManager")

@onready var cracking_progress_bar = $"../UI/CrackingProgress/ProgressBar"
var total_cracking_progress_ratio: float = 0

func _ready() -> void:
	GameStore.LevelStore.tower_count = towers.size()
	for tower in towers:
		var working_state_machine = tower.get_node("WorkingStateMachine")
		working_state_machine.node_switch_to("Invisible")
		# if tower.is_in_group("MasterTowers") and working_state_machine.is_state("Invisible"):
		# 	working_state_machine.node_switch_to("Initializing")

func _process(_delta: float) -> void:
	var tmp_total_cracking_progress: float = 0
	for tower in towers:
		tmp_total_cracking_progress += tower.cracking_progress
	total_cracking_progress_ratio = tmp_total_cracking_progress / (100 * towers.size())

	cracking_progress_bar.set_custom_minimum_size(Vector2(20, total_cracking_progress_ratio * 200))

func _on_signal_center_spy_manager_discovered(_source_spy, target_spy) -> void:
	show_spy(target_spy)

func show_spy(spy):
	# print(spy.node_status.in_section)
	if spy.is_in_group("InvisibleSpys") and spy.node_status.in_section:
		spy.get_node("WorkingStateMachine").node_switch_to("Unreachable")
		spy.add_to_group("VisibleSpys")
		spy.remove_from_group("InvisibleSpys")

func _on_signal_center_connection_established(start_node: Variant, end_node: Variant, _value) -> void:
	connection_manager.update_reachable_status()
	employ_spy(start_node)
	employ_spy(end_node)

	for tower in towers:
		if tower.node_status["reachable"]:
			employ_spy(tower)


func employ_spy(tower):
	print("Employing tower: ", tower.name)
	var working_state_machine = tower.get_node("WorkingStateMachine")
	if working_state_machine.is_state("Unreachable"):
		if working_state_machine.has_initialized:
			working_state_machine.node_switch_to("Idle")

		elif tower.connections:
			working_state_machine.node_switch_to("Initializing")
