extends Node

@onready var spy_data_file = FileAccess.open("res://data/spy_data.json", FileAccess.READ)
@onready var spys = get_tree().get_nodes_in_group("Spys")
@onready var clue_sound: AudioStreamPlayer
@onready var time_label = $time

var code_names: Array = []
var code_name_dict: Dictionary = {}

var timer: float = 0.0
var interval: float = 8.0  # 5秒生成一次线索

signal discover_clue

func _ready() -> void:
	var spy_data_json = JSON.parse_string(spy_data_file.get_as_text())
	code_names = spy_data_json.map(func(item): return item["codeName"])
	for spy in spys:
		var code_name = spy.code_name
		if not code_name in code_names:
			continue
		for spy_data in spy_data_json:
			if spy_data["codeName"] == code_name:
				spy.spy_data = spy_data
				code_name_dict[code_name] = spy_data

				if spy_data["data"]["isUndercover"]:
					spy.is_undercover = true
	
	# Setup clue discovery sound
	clue_sound = AudioStreamPlayer.new()
	add_child(clue_sound)
	clue_sound.stream = load("res://UI音效/发现情报2.wav")

func _process(delta: float) -> void:
	if not GameStore.SilencingStore.is_silencing:
		timer += delta
		if timer >= interval:
			timer = 0.0
			generate_random_clue()
	
	# 更新倒计时显示
	if time_label:
		var remaining_time = interval - timer
		time_label.text = "%.1f" % remaining_time

func get_all_spys_data(select_all = true, select_discovered = false, select_collected = false):
	var all_data = []
	for spy in spys:
		var match_discovered = select_discovered == spy.is_discovered
		var match_collected = select_collected == spy.is_collected
		var all_match = match_discovered and match_collected
		if select_all or all_match:
			all_data.append(spy.spy_data)
	return all_data

func get_not_discovered_spys_data():
	return get_all_spys_data(false, false, false)

func get_collected_spys_data():
	return get_all_spys_data(false, false, true)

func get_idle_spys():
	var idle_spys = []
	for spy in spys:
		var current_state = spy.working_state_machine.current_state
		var clue_button = spy.get_node("ClueButton")
		if current_state and current_state.spy_state_status["label"] == "Idle" and clue_button and not clue_button.visible:
			idle_spys.append(spy)
	return idle_spys

func generate_random_clue():
	var not_discovered_spys_data = get_not_discovered_spys_data()
	var new_discovered_spy_data = select_random_spy_data(not_discovered_spys_data)
	if not new_discovered_spy_data:
		return
	
	# 获取所有状态为Idle的间谍
	var idle_spys = get_idle_spys()
	if idle_spys.size() == 0:
		return
	
	# 随机选择一个Idle状态的间谍来显示线索
	var random_idle_spy = idle_spys[randi() % idle_spys.size()]
	random_idle_spy.discover_clue(new_discovered_spy_data)
	emit_signal("discover_clue", new_discovered_spy_data)
	clue_sound.play()  # Play the sound when a new clue is discovered

func select_random_spy_data(target_spy_data: Array) -> Dictionary:
	if target_spy_data.size() == 0:
		return {}
	var selected_spy_data = target_spy_data[randi() % target_spy_data.size()]
	return selected_spy_data
