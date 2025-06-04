class_name GameObjects
extends Node

var spys: Array
var visible_spys: Array
var invisible_spys: Array

var enemies: Array

var map_sections: Array

func _ready() -> void:
	spys = get_spys()
	visible_spys = get_visible_spys()
	invisible_spys = get_invisible_spys()

	map_sections = get_map_sections()

func get_spys():
	return get_tree().get_nodes_in_group("Spys")

func get_visible_spys():
	return get_tree().get_nodes_in_group("VisibleSpys")

func get_invisible_spys():
	return get_tree().get_nodes_in_group("InvisibleSpys")

func get_map_sections():
	return get_tree().get_nodes_in_group("MapSections")
