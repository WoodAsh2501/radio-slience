extends StateMachine

@onready var spy_instance = $"../"
@onready var spy_node = $"../SpyNode"
@onready var lable = $"../Label"
@onready var spy_detect_range = $"../SpyDetectRange"
@onready var enemy_detect_range = $"../EnemyDetectRange"

func spy_switch_to(state_name: String, data: Dictionary = {}):
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

	spy_node.scale = state_status["scale"] * Vector2(1, 1)
	lable.text = state_status["label"]
	spy_node.set_pickable(state_status["pickable"])
	spy_instance.visible = state_status["visible"]
	spy_detect_range.monitoring = state_status["detecting_spy"]
	enemy_detect_range.monitoring = state_status["detecting_enemy"]
