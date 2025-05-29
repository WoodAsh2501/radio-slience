extends Area2D

@export var range_radius: float = 100.0
@onready var radio_range_collision: CircleShape2D = get_node("RangeCollision").shape

func _process(_delta) -> void:
	if radio_range_collision:
		radio_range_collision.radius = range_radius
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, range_radius, Color.from_rgba8(255, 0, 0, 100), false)
