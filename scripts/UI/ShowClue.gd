extends Node

@onready var clue_info_label = $ClueInfoLabel
@onready var left_button = $LeftButton
@onready var right_button = $RightButton
@export var signal_center: Node

var collected_clues: Array = []
var current_clue_index: int = -1

func _ready():
	if signal_center:
		signal_center.connect("clue_collected", self._on_clue_collected)
	else:
		print("请在编辑器中设置 signal_center 节点引用！")
	
	# 连接按钮信号
	left_button.connect("pressed", self._on_left_button_pressed)
	right_button.connect("pressed", self._on_right_button_pressed)
	
	# 初始时禁用按钮
	update_button_states()

func _on_clue_collected(spy_data):
	var clue_text = ""
	if spy_data.has("data") and spy_data["data"].has("clue"):
		clue_text = spy_data["data"]["clue"]
	else:
		clue_text = "未找到线索内容"
	
	# 将新线索添加到数组
	collected_clues.append({
		"text": clue_text,
		"data": spy_data
	})
	
	# 更新当前索引到最新线索
	current_clue_index = collected_clues.size() - 1
	
	# 显示新线索
	display_current_clue()
	update_button_states()

func display_current_clue():
	if current_clue_index >= 0 and current_clue_index < collected_clues.size():
		clue_info_label.text = "收集到线索: " + collected_clues[current_clue_index]["text"]
	else:
		clue_info_label.text = "暂无线索"

func update_button_states():
	# 更新按钮状态
	left_button.disabled = current_clue_index <= 0
	right_button.disabled = current_clue_index >= collected_clues.size() - 1

func _on_left_button_pressed():
	if current_clue_index > 0:
		current_clue_index -= 1
		display_current_clue()
		update_button_states()

func _on_right_button_pressed():
	if current_clue_index < collected_clues.size() - 1:
		current_clue_index += 1
		display_current_clue()
		update_button_states()
