extends Line2D

class_name ConnectionLine

var nodes: Array = []
var value: float = 0

var highlighted: bool = false

func _ready() -> void:
	set_width(2)
	unhighlight()

func highlight() -> void:
	set_default_color(Color.from_rgba8(0, 255, 0, 255))

func unhighlight() -> void:
	set_default_color(Color.from_rgba8(255, 0, 0, 255))
