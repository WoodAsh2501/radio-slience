extends State

@onready var spy_node = get_node("../../SpyNode")
@onready var label = get_node("../../Label")
func enter(_data):
    spy_node.scale = Vector2(1,1)
    label.text = "Default"
