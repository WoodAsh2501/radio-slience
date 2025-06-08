extends State

@onready var label = $"../../Label"
@onready var spy = $"../../"

@onready var game_attributes = get_tree().get_nodes_in_group("GameAttributes")[0]

var spy_state_status = {
	"visible": true,
	"scale": 1.0,
	"label": "Initializing",
	"pickable": false,
	"detecting_spy": false,
	"detecting_enemy": false,
	"texture": preload("res://assets/UI/unreach.png")
}

var timer

func _init() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.connect("timeout", _on_timer_timeout)

func enter(_data):
	timer.start()

func _process(_delta: float) -> void:
	timer.wait_time = game_attributes.spy_init_time
	if not timer or timer.is_stopped():
		return
	label.text = "Initializing" + str("%0.2f" % timer.time_left)

func _on_timer_timeout() -> void:
	state_machine.node_switch_to("Idle")

func exit():
	state_machine.has_initialized = true
	spy.node_status["is_employed"] = true
