extends Label

func _process(_delta: float) -> void:
	if GameStore.SilencingStore.get_silence_state():
		text = "RADIO SILENCE"
	else:
		text = "RADIO ON"
