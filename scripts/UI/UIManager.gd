extends Node

# 存储所有面板的引用
var panels: Dictionary = {}

@onready var main_ui = $MainUI
@onready var menu_ui = $MenuUI
@onready var aa_ui = $AAUI

func _ready() -> void:
	# 获取所有面板节点
	for child in get_children():
		if child is Panel:
			panels[child.name] = child
			# 默认隐藏所有面板
			child.visible = false
	
	# 默认显示主UI，隐藏其他UI
	show_ui(main_ui)
	hide_ui(menu_ui)
	hide_ui(aa_ui)
	
	# 连接按钮信号
	if main_ui:
		# 假设MainUI中有两个按钮：menu_button 和 aa_button
		var menu_button = main_ui.get_node("menu_button")
		var aa_button = main_ui.get_node("aa_button")
		
		if menu_button:
			menu_button.pressed.connect(_on_menu_button_pressed)
		if aa_button:
			aa_button.pressed.connect(_on_aa_button_pressed)

# 切换到指定面板
func switch_to_panel(panel_name: String) -> void:
	# 隐藏所有面板
	for panel in panels.values():
		panel.visible = false
	
	# 显示目标面板
	if panels.has(panel_name):
		panels[panel_name].visible = true
	else:
		push_error("Panel not found: " + panel_name)

# 示例：绑定按钮信号
func _on_button_pressed(panel_name: String) -> void:
	switch_to_panel(panel_name)

func show_ui(ui: Node) -> void:
	if ui:
		ui.visible = true

func hide_ui(ui: Node) -> void:
	if ui:
		ui.visible = false

func _on_menu_button_pressed() -> void:
	hide_ui(main_ui)
	show_ui(menu_ui)

func _on_aa_button_pressed() -> void:
	hide_ui(main_ui)
	show_ui(aa_ui)
