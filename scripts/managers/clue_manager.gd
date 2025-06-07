extends Node

@onready var spy_data_file = FileAccess.open("res://data/spy_data.json", FileAccess.READ)
@onready var spys = get_tree().get_nodes_in_group("Spys")

var spy_data: Array = []
var spy_code_names: Array = []

var has_not_collected_clue = false

signal discover_clue

func _ready() -> void:
	spy_data = JSON.parse_string(spy_data_file.get_as_text())
	spy_code_names = spy_data.map(func(item): return item["codeName"])
	spy_data = spy_data.map(func(item):
		item.spy_instance = null
		return item
		)
	for spy in spys:
		var code_name = spy.code_name
		if not code_name in spy_code_names:
			continue
		spy_data = spy_data.map(func(item):
			if item["codeName"] == code_name:
				item.spy_instance = spy
			return item
			)

func generate_random_clue():
	var employed_spys_data = get_employed_spys_data()
	# var not_investigated_spy_data = employed_spys_data.filter(func(item): return not item.spy_instance.node_status.is_investigated)
	# var spy_investigated = select_random_spy_data(not_investigated_spy_data)
	# spys[randi() % spys.size()].discover_clue(spy_investigated)
	spys[randi() % spys.size()].discover_clue(select_random_spy_data(employed_spys_data))
	# emit_signal("discover_clue", spy_investigated["codeName"])
	# return spy_investigated

func select_random_spy_data(target_spy_data: Array) -> Dictionary:
	if target_spy_data.size() == 0:
		return {}
	return target_spy_data[randi() % target_spy_data.size()]

func get_investigated_spys_data():
	return spy_data.filter(func(item):
		if not item.spy_instance:
			return false
		return item.spy_instance.node_status.is_investigated)

func get_employed_spys_data():
	return spy_data.filter(func(item):
		if not item.spy_instance:
			return null
		return item.spy_instance.node_status.is_employed)

func process(_delta):
	pass
