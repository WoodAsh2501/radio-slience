extends Button

var _timer: Timer
var _is_blinking: bool = false
var _blink_timer: Timer
var _blink_count: int = 0
@onready var news_ui = $"../../NewsUI"
@onready var frame1 = news_ui.get_node("Frame1")

func _ready():
	# 初始状态设置为不可见
	visible = false
	news_ui.visible = false
	
	# 创建10秒计时器
	_timer = Timer.new()
	_timer.wait_time = 10.0
	_timer.one_shot = false
	_timer.timeout.connect(_on_timer_timeout)
	add_child(_timer)
	_timer.start()
	
	# 创建闪烁计时器
	_blink_timer = Timer.new()
	_blink_timer.wait_time = 0.5
	_blink_timer.one_shot = false
	_blink_timer.timeout.connect(_on_blink_timer_timeout)
	add_child(_blink_timer)
	
	# 连接按钮点击信号
	pressed.connect(_on_pressed)
	
	# 连接newsExit按钮的点击信号
	news_ui.get_node("newsExit").pressed.connect(_on_news_exit_pressed)

func _on_timer_timeout():
	# 10秒后开始闪烁
	visible = true
	_is_blinking = true
	_blink_count = 0
	_blink_timer.start()

func _on_blink_timer_timeout():
	# 切换按钮可见性实现闪烁效果
	visible = !visible
	_blink_count += 1
	
	# 闪烁3次后停止闪烁，保持可见
	if _blink_count >= 6:  # 因为每次闪烁包含显示和隐藏，所以需要6次切换
		_blink_timer.stop()
		_is_blinking = false
		visible = true

func _on_pressed():
	# 点击后停止闪烁并隐藏按钮
	_is_blinking = false
	_blink_timer.stop()
	visible = false
	
	# 随机选择一张图片
	var random_frame = randi() % 18 + 1  # 生成1-18的随机数
	var image_path = "res://assets/newsphoto/Frame " + str(random_frame) + ".png"
	var texture = load(image_path)
	
	# 设置Frame1的图片
	frame1.texture = texture
	
	# 显示NewsUI
	news_ui.visible = true

func _on_news_exit_pressed():
	# 隐藏NewsUI
	news_ui.visible = false
