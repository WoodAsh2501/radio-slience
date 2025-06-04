extends Node

# TODO: signal not only can be emitted from here.
signal map_section_unblocked

@export var spawn_section: Area2D
@export var master_spy: Node2D

func _ready() -> void:
	emit_signal("map_section_unblocked", spawn_section)
	# update_spy_section_data()


# TODO: 优化这个 看看怎么办
func _physics_process(delta: float) -> void:
	update_spy_section_data()

func update_spy_section_data():
	var map_sections = get_tree().get_nodes_in_group("MapSections")
	var spys = get_tree().get_nodes_in_group("Spys")

	for spy in spys:
		for section in map_sections:
			if is_spy_in_section(spy, section):
				spy.spy_status.in_section = section
				break


func is_spy_in_section(spy, map_section):
	var target_area: Area2D = spy.get_node("SpyBody")
	return map_section.overlaps_area(target_area)


func _on_signal_center_map_section_unblocked(_section:Variant) -> void:
	update_spy_section_data()
