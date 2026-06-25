extends Node

@export var curtain_menu_scene: String

func _input(event: InputEvent) -> void:
	_process_touch(event)
	_process_key(event)

func _process_touch(event) -> void:
	if event is InputEventScreenTouch and !event.pressed:
		return_to_main()
		
func _process_key(event) -> void:
	if event is InputEventKey and event.keycode == KEY_SPACE and !event.pressed:
		return_to_main()
			
func return_to_main() -> void:
	Events.change_level(curtain_menu_scene)
