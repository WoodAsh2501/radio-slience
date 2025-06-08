extends Label

func _process(_delta: float) -> void:
	text = "Action Points: " + str(GameStore.PlayStore.action_point)

func _on_signal_center_connection_established(_start_spy, _end_spy, _value):
	GameStore.PlayStore.action_point -= 1
