extends Node

# TODO: using Instances to manage spys.

signal create_enemy(enemy)
signal remove_enemy(enemy)

signal enemy_patrol_entered(spy, enemy)
signal enemy_patrol_exited(spy, enemy)
signal enemy_patrol_detected(spy, enemy)
signal enemy_patrol_captured(spy, enemy)

# signal building_connection_started(spy)
# signal building_connection_ended(spy)
# signal building_connection_abandoned(spy)

signal connection_established(start_node, end_node, value)
# signal connection_lost(start_node, end_node)

signal spy_manager_discovered(spy)
signal spy_manager_employed(spy)
signal spy_manager_lost(spy)
# signal spy_manager_fired(spy)

signal clue_discovered(spy_data)
signal clue_collected(spy_data)

signal map_section_unblocked(section)

func _ready() -> void:
	var spys = get_tree().get_nodes_in_group("Spys")
	var enemies = get_tree().get_nodes_in_group("Enemies")

	var connection_manager = $"../ConnectionManager"
	var clue_manager = $"../ClueManager"

	connect_map_section_signals()
	connect_enemy_patrol_signals(spys, enemies)
	connect_connection_signals(connection_manager)
	connect_spy_manager_signals(spys)
	connect_clue_signals(clue_manager, spys)


func connect_signal(emitter, emitted_signal, callback_fn):
	if not emitter.is_connected(emitted_signal, callback_fn):
		emitter.connect(emitted_signal, callback_fn)

## enemy patrol signals ##

func connect_enemy_patrol_signals(spys, enemies):
	for spy in spys:
		connect_signal(spy, "radio_range_enemy_entered", _on_spy_instance_radio_range_enemy_entered)
		connect_signal(spy, "radio_range_enemy_exited", _on_spy_instance_radio_range_enemy_exited)

		var CapturedStateMachine = spy.get_node("CapturedStateMachine")
		var WorkingStateMachine = spy.get_node("WorkingStateMachine")

		connect_signal(self, "enemy_patrol_detected", CapturedStateMachine._on_signal_center_enemy_patrol_detected)
		connect_signal(self, "enemy_patrol_captured", CapturedStateMachine._on_signal_center_enemy_patrol_captured)
		connect_signal(self, "enemy_patrol_captured", WorkingStateMachine._on_signal_center_enemy_patrol_captured)

	for enemy in enemies:
		connect_signal(enemy, "spy_detected", _on_enemy_instance_spy_detected)
		connect_signal(enemy, "spy_captured", _on_enemy_instance_spy_captured)

func _on_spy_instance_radio_range_enemy_entered(signal_spy, signal_enemy):
	emit_signal("enemy_patrol_entered", signal_spy, signal_enemy)

func _on_spy_instance_radio_range_enemy_exited(signal_spy, signal_enemy):
	emit_signal("enemy_patrol_exited", signal_spy, signal_enemy)

func _on_enemy_instance_spy_detected(signal_enemy, signal_spy):
	emit_signal("enemy_patrol_detected", signal_spy, signal_enemy)
	# print("Enemy detected spy: ", signal_spy)
func _on_enemy_instance_spy_captured(signal_enemy, signal_spy):
	emit_signal("enemy_patrol_captured", signal_spy, signal_enemy)

## connection signals ##

func connect_connection_signals(connection_manager):
	connect_signal(connection_manager, "new_connection_established", _on_connection_manager_new_connection_established)

func _on_connection_manager_new_connection_established(start_spy: Node, end_spy: Node, value: Variant) -> void:
	# print("New connection established between: ", start_spy, " and ", end_spy, " with value: ", value)
	emit_signal("connection_established", start_spy, end_spy, value)

## spy manager signals ##

func connect_spy_manager_signals(spys):
	for spy in spys:
		connect_signal(spy, "connect_range_spy_entered", _on_spy_manager_discovered)
		connect_signal(spy, "connect_range_spy_exited", _on_spy_manager_lost)

func _on_spy_manager_discovered(source_spy, target_spy):
	emit_signal("spy_manager_discovered", source_spy, target_spy)
	# print("Spy Manager Discovered: ", source_spy, " Target: ", target_spy)


# TODO: on spy lost
func _on_spy_manager_lost(source_spy, target_spy):
	# emit_signal("spy_manager_lost", source_spy, target_spy)
	pass


func _on_spy_manager_employed(spy) -> void:
	emit_signal("spy_manager_employed", spy)
	pass # Replace with function body.


## clue signals
func connect_clue_signals(clue_manager, spys):
	connect_signal(clue_manager, "discover_clue", _on_clue_manager_discover_clue)
	for spy in spys:
		connect_signal(spy, "collect_clue", _on_spy_instance_collect_clue)
		connect_signal(self, "clue_discovered", spy._on_signal_center_clue_discovered)
		connect_signal(self, "clue_collected", spy._on_signal_center_clue_collected)

func _on_clue_manager_discover_clue(spy_data):
	emit_signal("clue_discovered", spy_data)

func _on_spy_instance_collect_clue(spy_data):
	emit_signal("clue_collected", spy_data)

func connect_map_section_signals():
	var map_sections_manager = $"../MapSections"
	map_sections_manager.connect("map_section_unblocked", on_map_sections_manager_map_section_unblocked)
	# TODO: connect map section signal
	# Instances.map_sections.connect_signal()

func on_map_sections_manager_map_section_unblocked(map_section):
	# print("map unblocked")
	emit_signal("map_section_unblocked", map_section)

