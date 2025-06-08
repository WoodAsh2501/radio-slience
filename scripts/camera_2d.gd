extends Camera2D

var _last_mouse_position: Vector2 = Vector2.ZERO

var ratio = 0.8
var min_zoom = Vector2(0.6, 0.6)  # 设置最小缩放限制

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ScaleUp"):
		zoom += ratio * Vector2(0.1, 0.1)
	elif Input.is_action_just_pressed("ScaleDown"):
		var new_zoom = zoom - ratio * Vector2(0.1, 0.1)
		# 确保缩放不会小于最小值
		if new_zoom.x >= min_zoom.x and new_zoom.y >= min_zoom.y:
			zoom = new_zoom

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
