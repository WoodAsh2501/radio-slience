extends Camera2D

var _last_mouse_position: Vector2 = Vector2.ZERO

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ScaleUp"):
		zoom += Vector2(0.1, 0.1)
	elif Input.is_action_just_pressed("ScaleDown"):
		zoom -= Vector2(0.1, 0.1)

	if Input.is_action_just_pressed("Drag"):
		_last_mouse_position = get_global_mouse_position()
	elif Input.is_action_pressed("Drag"):
		var current_mouse_position = get_global_mouse_position()
		var screen_delta = current_mouse_position - _last_mouse_position
		var world_delta = screen_delta / zoom
		position -= world_delta
		_last_mouse_position = current_mouse_position
	elif Input.is_action_just_released("Drag"):
		_last_mouse_position = Vector2.ZERO
