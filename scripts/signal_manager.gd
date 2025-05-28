extends Node

@onready var signal_center = $"../SignalCenter"

@onready var spys = get_tree().get_nodes_in_group("Spys")
@onready var enemies = get_tree().get_nodes_in_group("Enemies")

func _process(_delta: float) -> void:
	for enemy in enemies:
		connect_signal(signal_center, "enemy_patrol_entered", enemy.on_enter_radio_range)
		connect_signal(signal_center, "enemy_patrol_exited", enemy.on_exit_radio_range)

func connect_signal(emitter, emitted_signal, callback_fn):
	if not emitter.is_connected(emitted_signal, callback_fn):
		emitter.connect(emitted_signal, callback_fn)
