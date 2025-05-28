extends ColorRect

func _process(_delta: float) -> void:
	if GameStore.SilencingStore.get_silence_state():
		self.visible = true
	else:
		self.visible = false
