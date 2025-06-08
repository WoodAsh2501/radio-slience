extends Button

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	# 等待0.5秒
	await get_tree().create_timer(0.5).timeout
	
	# 切换到主菜单场景
	get_tree().change_scene_to_file("res://scenes/main_container.tscn")
