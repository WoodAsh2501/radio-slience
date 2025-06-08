extends RigidBody2D

signal spy_detected
signal spy_captured
signal alert_value_changed # 发送信号到警戒条

@export var speed: float = 50.0
@onready var spys = get_tree().get_nodes_in_group("Spys")
@onready var label = $Label
@onready var alert_sound: AudioStreamPlayer

@onready var target_position: Vector2 = choose_random_position()

var locked_spy_array: Array = []
var target_spy: Node2D = null

var previous_direction: Vector2 = Vector2.LEFT
var current_direction: Vector2 = Vector2.LEFT

var detecting_spys: Array = []
var old_alert_value: int = 0
var alert_value: int = 0
var is_playing_alert: bool = false

func _ready() -> void:
	# Setup alert sound
	alert_sound = AudioStreamPlayer.new()
	add_child(alert_sound)
	alert_sound.stream = load("res://UI音效/警戒值过高警报3.wav")
	alert_sound.volume_db = -8.0  # 设置为原来的40%音量（约-8dB）

func _process(_delta: float) -> void:
	label.text = "Alert Value: " + str(alert_value)
	# on_alert_value_changed(old_alert_value, alert_value)

func _physics_process(delta: float) -> void:
	var current_target_position = target_position

	if locked_spy_array.size() > 0:
		target_spy = locked_spy_array[0]
		current_target_position = target_spy.position

		if position.distance_to(target_spy.position) < 10:
			emit_signal("spy_captured", self, target_spy)

			detecting_spys.erase(target_spy)
			locked_spy_array.erase(target_spy)
			target_spy = null

			print(locked_spy_array)

			if locked_spy_array.size() > 0:
				current_target_position = locked_spy_array[0].position
			else:
				current_target_position = choose_random_position()

	else:
		target_spy = null
		if position.distance_to(target_position) < 10:
			current_target_position = choose_random_position()

	target_position = current_target_position

	# for debug
	# if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
	# 	target_position = get_global_mouse_position()

	current_direction = (target_position - position).normalized()
	move_and_collide(current_direction * speed * delta)

	if is_spy_exposed():
		if alert_value < 100:
			update_alert_value(alert_value + 1)
	else:
		if alert_value > 0:
			update_alert_value(alert_value - 1)

func update_alert_value(new_value: int) -> void:
	old_alert_value = alert_value
	alert_value = new_value
	emit_signal("alert_value_changed", old_alert_value, alert_value) # 发送信号到警戒条
	on_alert_value_changed(old_alert_value, alert_value)
	
	# Handle alert sound
	if alert_value > 80 and not is_playing_alert:
		alert_sound.play()
		is_playing_alert = true
	elif alert_value <= 80 and is_playing_alert:
		alert_sound.stop()
		is_playing_alert = false

func lock_nearest_spy():
	var nearest = get_nearest_spy()
	if nearest:
		add_locked_spy(nearest)
		print("Locked spy: ", nearest.code_name)
		emit_signal("spy_detected", self, nearest)

func on_alert_value_changed(previous_value: int, new_value: int) -> void:
	if previous_value == new_value:
		return

	if previous_value < 100 and new_value >= 100:
		lock_nearest_spy()

func is_spy_exposed():
	return detecting_spys and not GameStore.SilencingStore.get_silence_state()


func choose_random_position():
	var random_direction = previous_direction.rotated(randf_range(-PI / 4, PI / 4))

	var random_distance = randf_range(50, 200)
	var random_position = position + random_direction * random_distance
	random_position = random_position.clamp(Vector2(get_viewport().size) * 0.1, Vector2(get_viewport().size) * 0.9)
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
	if enemy == self and spy.connections:
		detecting_spys.append(spy)

func on_exit_radio_range(spy, enemy):
	if enemy == self:
		detecting_spys.erase(spy)


func add_locked_spy(spy):
	if not locked_spy_array.has(spy):
		locked_spy_array.append(spy)

func _on_signal_center_enemy_patrol_detected(spy):
	add_locked_spy(spy)

func _on_signal_center_exposing_succeeded(spy):
	add_locked_spy(spy)
