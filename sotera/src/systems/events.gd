extends Node

signal level_change_start
signal level_change_enter
signal fade_out_done
signal fade_in_done
signal game_over

signal collect_contract
signal loose_life

var spinner_starting_positions = [
	0.09814815386375, # Standard maze
	0.49814815386375, # Scary maze
	0.29814815386375, # Bullet hell
]
var spinner_starting_position_idx = 0;
var target_scene = ""

func _ready() -> void:
	fade_out_done.connect(_do_level_change)

func change_level(scene:String):
	target_scene = scene
	level_change_start.emit()

func _do_level_change():
	get_tree().change_scene_to_file(target_scene)
	level_change_enter.emit()

# Spinner related global state management
func increase_spinner_starting_positoin():
	spinner_starting_position_idx += 1;
	spinner_starting_position_idx = spinner_starting_position_idx % spinner_starting_positions.size()

func get_spinner_start_offset():
	return spinner_starting_positions[spinner_starting_position_idx]
