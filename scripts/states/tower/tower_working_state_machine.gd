class_name TowerWorkingStateMachine
extends StateMachine

@onready var tower_instance = $"../"
@onready var tower_node = $"../TowerNode"
@onready var label = $"../Label"

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
	})

	tower_node.scale = set_status(state_status, "scale") * Vector2(1, 1)
	label.text = set_status(state_status, "label")
	tower_node.set_pickable(set_status(state_status, "pickable"))
	tower_instance.visible = set_status(state_status, "visible")

func set_status(state_status, key):
	var value = state_status[key]
	if not value in ["keep"]:
		return value

	var last_stable_state = get_state_by_name(last_stable_state_name)
	return last_stable_state.tower_state_status[key]

func node_switch_to_last_stable_state(data: Dictionary = {}):
	# print(last_stable_state_name)
	node_switch_to(last_stable_state_name, data)
