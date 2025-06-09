extends Node

@onready var card_node = $card
@onready var close_button = $close
@onready var info = $info
@export var signal_center: Node
@export var connection_manager: ConnectionManager

var is_first_click = true
var original_position = Vector2.ZERO
var current_spy = null

func _ready():
	if signal_center:
		signal_center.connect("click_spy", self._on_spy_clicked)
		signal_center.connect("click_empty", self._on_click_empty)
	else:
		push_error("请在编辑器中设置 signal_center 节点引用！")
	
	# 初始时隐藏close按钮和info
	if close_button:
		close_button.visible = false
		close_button.connect("pressed", self._on_close_pressed)
	if info:
		info.visible = false
	
	# 保存card的原始位置
	if card_node:
		original_position = card_node.position

func _on_spy_clicked(spy):
	if card_node and is_first_click:
		card_node.position.y -= 150
		is_first_click = false
		# 显示close按钮和info
		if close_button:
			close_button.visible = true
		if info:
			info.visible = true
	
	# 保存当前点击的spy并更新数据（每次都执行）
	current_spy = spy
	update_info_text(spy)

func update_info_text(spy):
	if info and spy.spy_data:
		var data = spy.spy_data.get("data", {})
		var infomation = data.get("infomation", {})
		
		# 基本信息
		var code_name_label = info.get_node("codename")
		
		if code_name_label:
			code_name_label.text = "代号: " + data.get("codeName", "未知")
		
		# 详细信息
		var gender_label = info.get_node("gender")
		var identity_label = info.get_node("identity")
		var birthday_label = info.get_node("birthday")
		var hobbies_label = info.get_node("hobbies")
		var characteristics_label = info.get_node("characteristics")
		var background_label = info.get_node("background")
		
		if gender_label:
			gender_label.text = infomation.get("gender", "未知")
		if identity_label:
			identity_label.text = infomation.get("virtualIdentity", "未知")
		if birthday_label:
			birthday_label.text = infomation.get("birthday", "未知")
		if hobbies_label:
			hobbies_label.text = infomation.get("hobbies", "未知")
		if characteristics_label:
			characteristics_label.text = infomation.get("characteristics", "未知")
		if background_label:
			background_label.text = infomation.get("background", "未知")

func _on_close_pressed():
	if card_node:
		card_node.position = original_position
		is_first_click = true
		if close_button:
			close_button.visible = false
		if info:
			info.visible = false
		# 清空info中的文字
		clear_info_text()
		# 取消所有连接的高亮
		if connection_manager:
			connection_manager.unhighlight_all_connections()
		# 隐藏当前间谍节点的删除按钮
		if current_spy and current_spy.has_node("DeleteButton"):
			current_spy.get_node("DeleteButton").visible = false
		# 清除当前spy引用
		current_spy = null

func clear_info_text():
	if info:
		var code_name_label = info.get_node("codename")
		var gender_label = info.get_node("gender")
		var identity_label = info.get_node("identity")
		var birthday_label = info.get_node("birthday")
		var hobbies_label = info.get_node("hobbies")
		var characteristics_label = info.get_node("characteristics")
		var background_label = info.get_node("background")
		
		if code_name_label:
			code_name_label.text = ""
		if gender_label:
			gender_label.text = ""
		if identity_label:
			identity_label.text = ""
		if birthday_label:
			birthday_label.text = ""
		if hobbies_label:
			hobbies_label.text = ""
		if characteristics_label:
			characteristics_label.text = ""
		if background_label:
			background_label.text = ""

func _on_click_empty():
	if card_node:
		card_node.position = original_position
		is_first_click = true
		if close_button:
			close_button.visible = false
		if info:
			info.visible = false
		# 清除当前spy引用
		current_spy = null
		# 清空info中的文字
		clear_info_text()
