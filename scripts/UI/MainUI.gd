extends Node

# 存储所有面板的引用
var panels: Dictionary = {}

@onready var menu_button = $menu_button
@onready var aa_button = $aa_button

func _ready() -> void:
	# 获取所有面板节点
	for child in get_children():
		if child is Panel:
			panels[child.name] = child
			# 默认隐藏所有面板
			child.visible = false

	# 连接按钮信号
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

func _on_menu_button_pressed() -> void:
	# 显示MenuUI
	get_parent().get_node("MenuUI").visible = true

func _on_aa_button_pressed() -> void:
	# 显示AAUI
	get_parent().get_node("AAUI").visible = true
