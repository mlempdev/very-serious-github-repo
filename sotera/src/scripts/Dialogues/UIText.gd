class_name UiText
extends Control

enum UiTextState { SHOWTEXT, NO_TEXT }

var state: UiTextState = UiTextState.NO_TEXT
var current_dialogue: DialogueJSON = null
var current_line_idx: int = 0
var timer: float = 0.0

# Tune this — you want even a slow reader to finish comfortably
@export var read_time_per_character: float = 0.05  

@onready var label: Label = $Label  

func _ready() -> void:
	visible = false

func _process(delta: float) -> void:
	if state == UiTextState.NO_TEXT:
		return

	timer -= delta

	if timer <= 0.0:
		_advance_line()

func _advance_line() -> void:
	current_line_idx += 1

	var next_line = _get_current_line()

	if next_line == null:
		# No more lines — hide everything
		on_stop_dialogue()
		return

	_show_line(next_line)

func _get_current_line() -> Variant:
	if current_dialogue == null:
		return null
	if current_line_idx >= current_dialogue.dialogue_lines.size():
		return null
	return current_dialogue.dialogue_lines[current_line_idx]

func _show_line(line: String) -> void:
	label.text = line
	timer = line.length() * read_time_per_character

func on_start_dialogue(dialogue: DialogueJSON) -> void:
	current_dialogue = dialogue
	current_line_idx = 0
	timer = 0.0
	state = UiTextState.SHOWTEXT
	visible = true

	var first_line = _get_current_line()
	if first_line == null:
		on_stop_dialogue()
		return

	_show_line(first_line)

func on_stop_dialogue() -> void:
	state = UiTextState.NO_TEXT
	visible = false
	current_dialogue = null
	current_line_idx = 0
	timer = 0.0
