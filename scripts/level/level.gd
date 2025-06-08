extends Node2D

var since_last_action_point_resume = 0.0
@onready var game_attributes = get_tree().get_nodes_in_group("GameAttributes")[0]


func _ready() -> void:
	GameStore.PlayStore.max_action_point = game_attributes.action_point_max
	GameStore.PlayStore.init_action_point()

func _process(_delta: float) -> void:
	GameStore.PlayStore.max_action_point = game_attributes.action_point_max
	GameStore.PlayStore.action_point_resume_time = game_attributes.action_point_recovery_time

	if GameStore.PlayStore.action_point > GameStore.PlayStore.max_action_point:
		GameStore.PlayStore.action_point = GameStore.PlayStore.max_action_point

	if since_last_action_point_resume < GameStore.PlayStore.action_point_resume_time:
		since_last_action_point_resume += get_process_delta_time()

	else:
		if GameStore.PlayStore.action_point < GameStore.PlayStore.max_action_point:
			GameStore.PlayStore.action_point += 1
		since_last_action_point_resume = 0.0
