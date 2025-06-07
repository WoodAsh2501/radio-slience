extends ProgressBar

var enemy: Node2D

func _ready() -> void:
	# 获取敌人节点
	enemy = get_tree().get_first_node_in_group("Enemies")
	if enemy:
		# 监听敌人的警戒值变化
		enemy.connect("alert_value_changed", _on_alert_value_changed)
	
	# 设置进度条的最大值
	max_value = 100

func _on_alert_value_changed(previous_value: int, new_value: int) -> void:
	#print(previous_value)
	value = new_value
