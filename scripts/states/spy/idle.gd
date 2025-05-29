extends State

@onready var spy_node = get_node("../../SpyNode")
@onready var spy_detect_range = get_node("../../SpyDetectRange")
@onready var enemy_detect_range = get_node("../../EnemyDetectRange")
@onready var label = get_node("../../Label")

func enter(_data):
	spy_node.scale = Vector2(1,1)
	label.text = "Idle"

	spy_node.set_pickable(true)
	spy_detect_range.monitoring = true
	enemy_detect_range.monitoring = true
