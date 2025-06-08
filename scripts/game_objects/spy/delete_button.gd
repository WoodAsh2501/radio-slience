extends Button

signal delete_spy(spy)

@onready var spy_instance = get_parent()

func _ready():
	visible = false
	# 连接按钮的 pressed 信号
	pressed.connect(_on_delete_button_pressed)

func _on_signal_center_click_spy(clicked_spy):
	if clicked_spy == spy_instance and spy_instance.node_status["is_employed"]:
		visible = true
	else:
		visible = false

func _on_signal_center_click_empty():
	visible = false

# 新增：处理按钮按下事件并发射信号
func _on_delete_button_pressed():
	emit_signal("delete_spy", spy_instance)
	visible = false
