extends RigidBody2D

signal spy_detected

@export var speed: float = 20.0
@onready var spys = get_tree().get_nodes_in_group("Spys")
@onready var label = $Label

@onready var target_position: Vector2 = choose_random_position()
var previous_direction: Vector2 = Vector2.LEFT
var current_direction: Vector2 = Vector2.LEFT

var detecting_spys: Array = []
var alert_value: int = 0

func _process(_delta: float) -> void:
	label.text = "Alert Value: " + str(alert_value)

func _physics_process(delta: float) -> void:
	if alert_value == 100:
		detect_spy(get_nearest_spy())

	if position.distance_to(target_position) < 10:
		target_position = select_new_position()

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		target_position = get_global_mouse_position()
			
	current_direction = (target_position - position).normalized()
	move_and_collide(current_direction * speed * delta)

	if is_spy_exposed():
		if alert_value < 100:
			alert_value += 1
	else:
		if alert_value > 0:
			alert_value -= 1

func detect_spy(spy):
	target_position = spy.position
	emit_signal("spy_detected", self, spy)

func is_spy_exposed():
	return detecting_spys and not GameStore.SilencingStore.get_silence_state()

func select_new_position():
	if is_spy_exposed():
		return get_nearest_spy().position
	return choose_random_position()
		
func choose_random_position():
	var random_direction = previous_direction.rotated(randf_range(-PI / 4, PI / 4))

	var random_distance = randf_range(50, 200)
	var random_position = position + random_direction * random_distance
	random_position = random_position.clamp(Vector2(0, 0), Vector2(get_viewport().size) * 0.8)
	previous_direction = random_direction
	return random_position

func get_nearest_spy():
	var spy_distance_array = detecting_spys.map(func(spy):
		return {
			"distance": position.distance_to(spy.position),
			"spy": spy
		})
	var sort_by_distance = func(a, b):
		return a.distance < b.distance

	var nearest_spy = Utils.sorted_custom(spy_distance_array, sort_by_distance)[0].spy

	return nearest_spy

func on_enter_radio_range(spy, enemy):
	if enemy == self:
		detecting_spys.append(spy)

func on_exit_radio_range(spy, enemy):
	if enemy == self:
		detecting_spys.erase(spy)
