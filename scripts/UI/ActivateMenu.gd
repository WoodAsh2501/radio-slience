extends Node

@onready var menu_button = $MainUI/Menu
@onready var menu_ui = $MenuUI
@onready var back_button = $MenuUI/Back

func _ready():
	# 初始时隐藏菜单
	if menu_ui:
		menu_ui.visible = false
	
	# 确保Menu是Button
	if not menu_button is Button:
		push_error("Menu 必须是 Button 类型的节点！")
		return
	
	# 连接按钮点击事件
	menu_button.connect("pressed", self._on_menu_pressed)
	
	# 连接Back按钮点击事件
	if back_button:
		back_button.connect("pressed", self._on_back_pressed)
	else:
		push_error("未找到Back按钮！")

func _on_menu_pressed():
	# 当点击Menu按钮时显示MenuUI
	if menu_ui:
		menu_ui.visible = true
		print("Menu button pressed, showing MenuUI")

func _on_back_pressed():
	# 当点击Back按钮时隐藏MenuUI
	if menu_ui:
		menu_ui.visible = false
