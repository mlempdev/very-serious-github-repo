extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Events.level_change_start.connect(fade_out)
	Events.level_change_enter.connect(fade_in)

func fade_out():
	# Fade to black
	animation_player.play("fade_to_black")
	# Wait until screen is black
	await animation_player.animation_finished
	Events.fade_out_done.emit()

func fade_in():
	# Fade to black
	print("fade in start")
	animation_player.play_backwards("fade_to_black")
	await animation_player.animation_finished
	print("fade in done")
