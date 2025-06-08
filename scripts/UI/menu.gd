extends Button

@onready var menu_ui = get_node("/root/Node2D/UIManager/MenuUI")
@onready var main_ui = get_node("/root/Node2D/UIManager")

func _ready() -> void:
	pressed.connect(_on_pressed)
	# 确保初始状态是隐藏的
	menu_ui.visible = false

func _on_pressed() -> void:
	# 等待0.5秒
	await get_tree().create_timer(0.5).timeout
	
	# 显示菜单UI
	menu_ui.visible = true
	
	# 隐藏其他UI元素
	for child in main_ui.get_children():
		if child != menu_ui:
			child.visible = false
