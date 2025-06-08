extends Node
@onready var game_attributes = get_tree().get_nodes_in_group("GameAttributes")[0]

func _process(_delta: float) -> void:
	PlayStore.max_action_point = game_attributes.action_point_max
	PlayStore.action_point_resume_time = game_attributes.action_point_recovery_time

	if PlayStore.action_point > PlayStore.max_action_point:
		PlayStore.action_point = PlayStore.max_action_point

func _ready() -> void:
	PlayStore.max_action_point = game_attributes.action_point_max
	PlayStore.init_action_point()

class LevelStore:
	static var tower_count = 1

class PlayStore:
	static var is_playing = false
	static var playing_speed = 1.0

	static func get_playing_speed() -> float:
		return playing_speed

	static func set_playing_speed(speed: float):
		playing_speed = speed

	static func pause():
		is_playing = false

	static func resume():
		is_playing = true

	static var action_point_resume_time = 5.0
	static var max_action_point = 3
	static var action_point = 0

	static func init_action_point():
		action_point = max_action_point

class SilencingStore:
	static var is_silencing = false

	static func get_silence_state() -> bool:
		return is_silencing

	static func set_silence(state: bool = true):
		is_silencing = state

class ConnectingStore:
	static var is_connecting = false
	static var start_node = null
	static var end_node = null

	static var tower_reachability = {}

	static func initialize_tower_reachability(towers):
		for tower in towers:
			tower_reachability[tower] = false
