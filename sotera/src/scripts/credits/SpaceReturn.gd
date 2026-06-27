extends Node
class_name SpaceReturn

@export var curtain_menu_scene: String

func _input(event: InputEvent) -> void:
	_process_touch(event)
	_process_key(event)

func _process_touch(event) -> void:
	if event is InputEventScreenTouch and !event.pressed:
		action()
		
func _process_key(event) -> void:
	if event is InputEventKey and event.keycode == KEY_ESCAPE and !event.pressed:
		action()
			
func action() -> void:
	Events.change_level(curtain_menu_scene) # return to main
