extends Node

signal create_enemy(enemy)
signal remove_enemy(enemy)

signal enemy_patrol_entered(spy, enemy)
signal enemy_patrol_exited(spy, enemy)
signal enemy_patrol_detected(spy, enemy)

# signal building_connection_started(spy)
# signal building_connection_ended(spy)
# signal building_connection_abandoned(spy)

signal connection_established(start_node, end_node)
# signal connection_lost(start_node, end_node)

signal spy_manager_discovered(spy)
signal spy_manager_lost(spy)
# signal spy_manager_fired(spy)

func _ready() -> void:
	var spys = get_tree().get_nodes_in_group("Spys")
	var enemies = get_tree().get_nodes_in_group("Enemies")

	var connections_store = $"../ConnectionsStore"

	connect_enemy_patrol_signals(spys, enemies)
	connect_connection_signals(connections_store)
	connect_spy_manager_signals(spys)

func connect_signal(emitter, emitted_signal, callback_fn):
	if not emitter.is_connected(emitted_signal, callback_fn):
		emitter.connect(emitted_signal, callback_fn)

## enemy patrol signals ##

func connect_enemy_patrol_signals(spys, enemies):
	for spy in spys:
		connect_signal(spy, "radio_range_enemy_entered", _on_spy_instance_radio_range_enemy_entered)
		connect_signal(spy, "radio_range_enemy_exited", _on_spy_instance_radio_range_enemy_exited)
	
	for enemy in enemies:
		connect_signal(enemy, "spy_detected", _on_enemy_instance_spy_detected)

func _on_spy_instance_radio_range_enemy_entered(signal_spy, signal_enemy):
	emit_signal("enemy_patrol_entered", signal_spy, signal_enemy)

func _on_spy_instance_radio_range_enemy_exited(signal_spy, signal_enemy):
	emit_signal("enemy_patrol_exited", signal_spy, signal_enemy)

func _on_enemy_instance_spy_detected(signal_enemy, signal_spy):
	emit_signal("enemy_patrol_detected", signal_spy, signal_enemy)

## connection signals ##

func connect_connection_signals(connection_store):
	connect_signal(connection_store, "connecting_complete", _on_connection_store_connection_established)

func _on_connection_store_connection_established(start_node, end_node):
	emit_signal("connection_established", start_node, end_node)

## spy manager signals ##

func connect_spy_manager_signals(spys):
	for spy in spys:
		connect_signal(spy, "connect_range_spy_entered", _on_spy_manager_discovered)
		connect_signal(spy, "connect_range_spy_exited", _on_spy_manager_lost)

func _on_spy_manager_discovered(source_spy, target_spy):
	emit_signal("spy_manager_discovered", source_spy, target_spy)
	print("Spy Manager Discovered: ", source_spy, " Target: ", target_spy)

func _on_spy_manager_lost(source_spy, target_spy):
	# emit_signal("spy_manager_lost", source_spy, target_spy)
	pass
