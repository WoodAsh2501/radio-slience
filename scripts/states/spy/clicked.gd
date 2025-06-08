extends State

var spy_state_status = {
	"visible": true,
	"scale": 1.7,
	"label": "Clicked",
	"pickable": true,
	"detecting_spy": "keep",
	"detecting_enemy": "keep",
}

signal click_spy

var since_last_click: float = 0.0

func _process(_delta):
	if not state_machine.is_state("Clicked"):
		return

	since_last_click += get_process_delta_time()

	if (
			Input.is_action_just_released("MouseClick")
			or not is_inside_node()
		):
		_on_mouse_pressing_end()

func enter(_data):
	since_last_click = 0.0

func is_inside_node(node=parent_node):
	var mouse_position = node.get_global_mouse_position()
	return mouse_position.distance_to(node.global_position) < 16

func _on_mouse_pressing_end():
	if since_last_click > 0.05:
		state_machine.node_switch_to("Connecting")
	# else:
	# 	if is_inside_node():
	# 	else:
	# 		state_machine.node_switch_to_last_stable_state()

func exit():
	if is_inside_node():
		emit_signal("click_spy", parent_node)
		print("Mouse click")
	since_last_click = 0.0
