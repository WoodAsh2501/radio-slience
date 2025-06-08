extends Node2D

var since_last_action_point_resume = 0.0


func _process(_delta: float) -> void:
	if since_last_action_point_resume < GameStore.PlayStore.action_point_resume_time:
		since_last_action_point_resume += get_process_delta_time()

	else:
		if GameStore.PlayStore.action_point < GameStore.PlayStore.max_action_point:
			GameStore.PlayStore.action_point += 1
		since_last_action_point_resume = 0.0
