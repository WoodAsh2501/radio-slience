extends State

@onready var spy_instance = get_node("../../")
@onready var spy_node = get_node("../../SpyNode")
@onready var label = get_node("../../Label")

func enter(_data):
	spy_node.scale = Vector2(1,1)
	spy_instance.visible = false
	label.text = "Invisible"
