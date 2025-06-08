extends Button

@onready var menu_ui = get_node("/root/Node2D/UIManager/MenuUI")
@onready var main_ui = get_node("/root/Node2D/UIManager")

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	# 等待0.5秒
	await get_tree().create_timer(0.5).timeout
	
	# 隐藏菜单UI
	menu_ui.visible = false
	
	# 恢复其他UI元素
	for child in main_ui.get_children():
		if child != menu_ui:
			child.visible = true
