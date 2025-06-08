extends Area2D

@onready var game_attributes = get_tree().get_nodes_in_group("GameAttributes")[0]

@onready var radio_range_collision: CircleShape2D = get_node("RangeCollision").shape

func _process(_delta) -> void:
	if radio_range_collision:
		radio_range_collision.radius = game_attributes.spy_discover_range
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, game_attributes.spy_discover_range, Color.from_rgba8(255, 0, 0, 100), false)
