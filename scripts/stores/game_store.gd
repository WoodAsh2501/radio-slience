extends Node

class LevelStore:
	static var tower_count = 1

class SpyInformationStore:
	static var employed_spys_information: Array = []

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
