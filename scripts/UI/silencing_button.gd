extends Button

var is_pressing = false

func _ready() -> void:
	self.button_down.connect(on_pressed)
	self.button_up.connect(on_released)

func _process(_delta: float) -> void:
	if Input.is_action_pressed("Silencing") or is_pressing:
		GameStore.SilencingStore.set_silence(true)
	else:
		GameStore.SilencingStore.set_silence(false)

func on_pressed() -> void:
	is_pressing = true

func on_released() -> void:
	is_pressing = false
