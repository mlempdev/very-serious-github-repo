extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicPlayer.play_track(MusicPlayer.BULLET_THEME, 0.8, 9.0, -9.0)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _exit_tree() -> void:
	MusicPlayer.stop_track(2.0)
