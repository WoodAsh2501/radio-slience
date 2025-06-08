extends Button

@onready var frame45 = $"../PanelContainer/Frame45"

func _ready() -> void:
	# 设置按钮为完全透明
	modulate.a = 0.0  # 0.0 表示完全透明，1.0 表示完全不透明
	# 连接按钮的按下信号
	pressed.connect(_on_pressed)
	print("Button ready and signal connected")  # 调试信息

func _on_pressed() -> void:
	print("Button pressed!")  # 调试信息
	
	# 创建点击动效
	var tween = create_tween()
	tween.tween_property(frame45, "scale", Vector2(0.45, 0.45), 0.1)  # 先缩小
	tween.tween_property(frame45, "scale", Vector2(0.531746, 0.531746), 0.1)  # 再恢复
	
	# 等待动效完成
	await tween.finished
	
	# 等待0.6秒
	await get_tree().create_timer(0.6).timeout
	
	# 切换到 level 场景
	get_tree().change_scene_to_file("res://scenes/level.tscn")
