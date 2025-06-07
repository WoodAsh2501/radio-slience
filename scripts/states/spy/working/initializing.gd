extends State

@onready var label = $"../../Label"
@onready var spy = $"../../"

var spy_state_status = {
	"visible": true,
	"scale": 1.0,
	"label": "Initializing",
	"pickable": false,
	"detecting_spy": false,
	"detecting_enemy": false,
}

var timer

func _init() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.1
	timer.one_shot = true
	timer.connect("timeout", _on_timer_timeout)

func enter(_data):
	timer.start()

func _process(_delta: float) -> void:
	if not timer or timer.is_stopped():
		return
	label.text = "Initializing" + str("%0.2f" % timer.time_left)

func _on_timer_timeout() -> void:
	# if spy.is_in_group("MasterSpys"):
		# state_machine.node_switch_to("Idle")
		# return
	# state_machine.node_switch_to("Unreachable")
	state_machine.node_switch_to("Idle")

func exit():
	state_machine.has_initialized = true
	spy.node_status["is_employed"] = true
