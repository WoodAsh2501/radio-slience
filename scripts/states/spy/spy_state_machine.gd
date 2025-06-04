extends StateMachine

@onready var spy_instance = $"../"
@onready var spy_node = $"../SpyNode"
@onready var lable = $"../Label"
@onready var spy_detect_range = $"../SpyDetectRange"
@onready var enemy_detect_range = $"../EnemyDetectRange"


var last_stable_state_name: String

func spy_switch_to(state_name: String, data: Dictionary = {}):
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
	})

	spy_node.scale = set_status(state_status, "scale") * Vector2(1, 1)
	lable.text = set_status(state_status, "label")
	spy_node.set_pickable(set_status(state_status, "pickable"))
	spy_instance.visible = set_status(state_status, "visible")
	spy_detect_range.monitoring = set_status(state_status, "detecting_spy")
	enemy_detect_range.monitoring = set_status(state_status, "detecting_enemy")

func set_status(state_status, key):
	var value = state_status[key]
	if not value in ["keep"]:
		return value

	var last_stable_state = get_state_by_name(last_stable_state_name)
	return last_stable_state.spy_state_status[key]

func spy_switch_to_last_stable_state(data: Dictionary = {}):
	# print(last_stable_state_name)
	spy_switch_to(last_stable_state_name, data)
