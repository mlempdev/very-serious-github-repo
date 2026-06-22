extends Node

signal level_change_start
signal level_change_enter
signal fade_out_done
signal fade_in_done
signal game_over

var target_scene = ""

func _ready() -> void:
	fade_out_done.connect(_do_level_change)

func change_level(scene:String):
	target_scene = scene
	level_change_start.emit()

func _do_level_change():
	get_tree().change_scene_to_file(target_scene)
	level_change_enter.emit()
