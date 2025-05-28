class_name MouseUtils

static func get_local_mouse_position(current_node) -> Vector2:
	return current_node.to_local(current_node.get_global_mouse_position())

static func is_mouse_in_range(current_node, radius) -> bool:
	var local_mouse_position = MouseUtils.get_local_mouse_position(current_node)
	return local_mouse_position.length() <= radius
