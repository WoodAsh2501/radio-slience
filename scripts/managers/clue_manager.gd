extends Node

@onready var spy_data_file = FileAccess.open("res://data/spy_data.json", FileAccess.READ)
@onready var spys = get_tree().get_nodes_in_group("Spys")

var code_names: Array = []
var code_name_dict: Dictionary = {}

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

func generate_random_clue():
	var not_discovered_spys_data = get_not_discovered_spys_data()
	var new_discovered_spy_data = select_random_spy_data(not_discovered_spys_data)
	if not new_discovered_spy_data:
		return
	spys[randi() % spys.size()].discover_clue(new_discovered_spy_data)
	emit_signal("discover_clue", new_discovered_spy_data)

func select_random_spy_data(target_spy_data: Array) -> Dictionary:
	if target_spy_data.size() == 0:
		return {}
	var selected_spy_data = target_spy_data[randi() % target_spy_data.size()]
	return selected_spy_data
