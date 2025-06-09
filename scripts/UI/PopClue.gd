extends Node

@onready var pop_clue = $PopClue
@onready var clue_info_label = $PopClue/ClueInfoLabel
@onready var close_button = $PopClue/close
@export var signal_center: Node

func _ready():
	# 设置节点在游戏暂停时仍能处理输入
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	if signal_center:
		signal_center.connect("clue_collected", self._on_clue_collected)
	else:
		push_error("请在编辑器中设置 signal_center 节点引用！")
	
	# 初始时隐藏弹出框
	if pop_clue:
		pop_clue.visible = false
	
	# 连接关闭按钮信号
	if close_button:
		close_button.connect("pressed", self._on_close_pressed)

func _on_clue_collected(spy_data):
	# 暂停游戏
	get_tree().paused = true
	
	var clue_text = ""
	if spy_data.has("data") and spy_data["data"].has("clue"):
		clue_text = spy_data["data"]["clue"]
	else:
		clue_text = "未找到线索内容"
	
	# 显示线索信息
	if clue_info_label:
		clue_info_label.text = "收集到线索: " + clue_text
	
	# 显示弹出框
	if pop_clue:
		pop_clue.visible = true

func _on_close_pressed():
	# 恢复游戏
	get_tree().paused = false
	
	if pop_clue:
		pop_clue.visible = false
	if clue_info_label:
		clue_info_label.text = ""
