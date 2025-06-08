class_name SpyWorkingStateMachine
extends StateMachine

@onready var spy_instance = $"../"
@onready var spy_node = $"../SpyNode"
@onready var label = $"../Label"
@onready var spy_detect_range = $"../SpyDetectRange"
@onready var enemy_detect_range = $"../EnemyDetectRange"
@onready var sprite = $"../SpyNode/Sprite"

var last_stable_state_name: String
var has_initialized: bool = false

func node_switch_to(state_name: String, data: Dictionary = {}):
	if state_name in ["Idle", "Unreachable"]:
		last_stable_state_name = state_name
	switch_to(state_name, data)
	var state = get_state_by_name(state_name)
	var state_status = (state.spy_state_status
		if "spy_state_status" in state
		else {
		"visible": true,
		"scale": 1.0,
		"label": "No State",
		"pickable": true,
		"detecting_spy": true,
		"detecting_enemy": true,
		"texture": preload("res://assets/UI/unreach.png")
	})

	spy_node.scale = set_status(state_status, "scale") * Vector2(1, 1)
	label.text = set_status(state_status, "label")
	spy_node.set_pickable(set_status(state_status, "pickable"))
	spy_instance.visible = set_status(state_status, "visible")
	spy_detect_range.monitoring = set_status(state_status, "detecting_spy")
	enemy_detect_range.monitoring = set_status(state_status, "detecting_enemy")
	
	# 设置贴图
	if sprite and state_status.has("texture"):
		sprite.texture = state_status["texture"]

func set_status(state_status, key):
	if not state_status.has(key):
		return null
		
	var value = state_status[key]
	if not value in ["keep"]:
		return value

	var last_stable_state = get_state_by_name(last_stable_state_name)
	if last_stable_state and "spy_state_status" in last_stable_state and last_stable_state.spy_state_status.has(key):
		return last_stable_state.spy_state_status[key]
	return null

func node_switch_to_last_stable_state(data: Dictionary = {}):
	# print(last_stable_state_name)
	node_switch_to(last_stable_state_name, data)

func _on_signal_center_enemy_patrol_captured(spy, _enemy):
	if spy == spy_instance:
		# print("Spy Captured State Machine: Spy Captured by Enemy")
		node_switch_to("Captured")
