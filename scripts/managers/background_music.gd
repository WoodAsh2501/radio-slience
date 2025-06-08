extends Node

@onready var music_player: AudioStreamPlayer

func _ready() -> void:
	# Create and setup music player
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.stream = load("res://UI音效/backgroundmusic.mp3")
	music_player.volume_db = -10.0  # 设置一个合适的音量
	music_player.play()

func _process(_delta: float) -> void:
	# 如果音乐播放完毕，重新开始播放
	if not music_player.playing:
		music_player.play() 