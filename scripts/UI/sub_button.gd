extends Button

@onready var selected_sprites = [
	get_node("/root/Node2D/UIManager/MenuUI/PanelContainer/Selected"),
	get_node("/root/Node2D/UIManager/MenuUI/PanelContainer/Selected2"),
	get_node("/root/Node2D/UIManager/MenuUI/PanelContainer/Selected3"),
	get_node("/root/Node2D/UIManager/MenuUI/PanelContainer/Selected4"),
	get_node("/root/Node2D/UIManager/MenuUI/PanelContainer/Selected5")
]

@onready var selected_texture = preload("res://assets/menuassets/selected.png")
@onready var not_selected_texture = preload("res://assets/menuassets/noselsct.png")

var current_volume_level = 5

func _ready() -> void:
	pressed.connect(_on_pressed)
	# 初始化音量显示
	update_volume_display()

func _on_pressed() -> void:
	if current_volume_level > 0:
		current_volume_level -= 1
		update_volume_display()
		update_audio_volume()

func update_volume_display() -> void:
	for i in range(5):
		if i < current_volume_level:
			selected_sprites[i].texture = selected_texture
		else:
			selected_sprites[i].texture = not_selected_texture

func update_audio_volume() -> void:
	# 将音量级别（0-5）映射到实际音量（0-1）
	var volume = current_volume_level / 5.0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(volume))
