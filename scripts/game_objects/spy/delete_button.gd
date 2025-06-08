extends Button

@onready var spy_instance = get_parent()

func _ready():
	visible = false

func _on_signal_center_click_spy(clicked_spy):
	if clicked_spy == spy_instance:
		visible = true
	else:
		visible = false

func _on_signal_center_click_empty():
	visible = false
