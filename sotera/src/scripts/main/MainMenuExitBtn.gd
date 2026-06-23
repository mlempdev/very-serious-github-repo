extends MainMenuBtn

class_name MainMenuExitBtn

var pressed: bool = false # self tracking state

func _gui_input(event) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_process_input(event.pressed)
	elif event is InputEventScreenTouch:
		_process_input(event.pressed)
		
				
func _process_input(is_pressed: bool) -> void:
	if is_pressed: pressed = true
	elif pressed:
		pressed = false
		_on_click()
		
func _on_click() -> void:
	curtain_system.open_full()
	jump_scare.start_jumpscare()
