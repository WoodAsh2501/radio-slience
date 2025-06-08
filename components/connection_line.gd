extends Line2D

class_name ConnectionLine

var nodes: Array = []
var value: float = 0
var highlighted: bool = false
var connection_sound: AudioStreamPlayer

func _ready() -> void:
	set_width(2)
	unhighlight()
	
	# Only play sound if this is not a preview line
	if not is_in_group("preview_line"):
		# Create and setup audio player
		connection_sound = AudioStreamPlayer.new()
		add_child(connection_sound)
		connection_sound.stream = load("res://UI音效/连线2.wav")
		connection_sound.play()

func highlight() -> void:
	set_default_color(Color.from_rgba8(0, 255, 0, 255))

func unhighlight() -> void:
	set_default_color(Color.from_rgba8(255, 0, 0, 255))
