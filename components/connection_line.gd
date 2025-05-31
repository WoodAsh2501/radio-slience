extends Line2D

class_name ConnectionLine

var nodes: Array = []
var value: float = 0

func _ready() -> void:
	set_width(2)
	set_default_color(Color.from_rgba8(255, 0, 0, 255))
