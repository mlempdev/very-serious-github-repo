extends Area2D

@export var curtains: CurtainSystem
@export var dialogue: Dialogue

var index: int = -1

func _input(e: InputEvent) -> void:
	if !curtains.closed(): return

	if (e is InputEventScreenTouch or e is InputEventMouseButton) and !e.pressed:
		force_touch_up()

# pressing polying inside world
func _input_event(viewport: Viewport, e: InputEvent, shape_idx: int) -> void:
	if   e is InputEventScreenTouch: touch_down_up_action(e, e.index)
	elif e is InputEventMouseButton: touch_down_up_action(e, 0)

func touch_down_up_action(event: InputEvent, index: int) -> void:
	if event.pressed: touch_down(index)
	else: touch_up(index)

func force_touch_up() -> void:
	_perform_click()
	self.index = -1
	
func touch_up(index: int) -> void:
	if index != self.index: return
	
	_perform_click()
	self.index = -1
	
func touch_down(index: int) -> void:
	if self.index != -1: return
	self.index = index

func _perform_click() -> void:
	if !dialogue.is_finished(): return
	
	if curtains.closed(): curtains.open_full()
	elif curtains.opened(): curtains.close_full()
