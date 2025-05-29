extends State

@onready var spy_instance = get_node("../../")
@onready var spy_node = get_node("../../SpyNode")
@onready var label = get_node("../../Label")

var timer

func _init() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 2.0
	timer.one_shot = true
	timer.connect("timeout", _on_timer_timeout)

func enter(_data):
	spy_node.scale = Vector2(1, 1)
	label.text = "Initializing"
	spy_instance.visible = true
	timer.start()
	
func _process(_delta: float) -> void:
	if not timer or timer.is_stopped():
		return
	label.text = "Initializing" + str("%0.2f" % timer.time_left)

func _on_timer_timeout() -> void:
	state_machine.switch_to("Idle")
