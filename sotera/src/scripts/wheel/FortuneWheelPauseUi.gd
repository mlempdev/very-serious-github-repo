extends SpaceReturn
class_name PauseBox

enum PauseBoxState{ HIDDEN, APPEARING, SHOWN, DISAPPEARING }
@export var range_full_appear_visibility_time: Vector2 = Vector2(0.5, 1.5)
@export var curtains: CurtainSystem
@export var dialogue: Dialogue

@onready var pause = $Pause
@onready var space_return = $"Space To Return"

var _state: PauseBoxState = PauseBoxState.HIDDEN
var _time: float = 0.0
var _max_time: float
var _minigame_pause_visual_block: bool = false # reset to fasle after scene reload

func _ready() -> void:
	# auto hide ... enabled here cause Editor visibility
	pause.modulate.a = 0.0
	space_return.modulate.a = 0.0
	
func _process(delta: float) -> void:
	match _state:
		PauseBoxState.APPEARING: _update_appearing(delta)
		PauseBoxState.DISAPPEARING: _update_disapeparing(delta)

func _update_appearing(delta: float) -> void:
	_time = min(_time + delta, _max_time)
	if _time == _max_time: _state = PauseBoxState.SHOWN
	
	_update_visibility()
	
func _update_disapeparing(delta: float) -> void:
	_time = max(_time - delta, 0.0)
	if _time == 0.0: _state = PauseBoxState.HIDDEN
	
	_update_visibility()
	
func _update_visibility() -> void:
	var t: float = _time / _max_time
	var alpha: float = TweenUtils.ease_out_quart(t)
	
	var opacity: float = alpha

	
	pause.modulate.a = opacity
	space_return.modulate.a = opacity
	
func show_pause() -> void:
	var skip: bool = _state == PauseBoxState.APPEARING || _state == PauseBoxState.SHOWN ||  \
					 _minigame_pause_visual_block # closing curtains to minigame blocks show this
	if skip: return
	
	_time = 0.0
	_max_time = randf_range(range_full_appear_visibility_time.x, range_full_appear_visibility_time.y)
	
	_state = PauseBoxState.APPEARING

# override default behavior of super class
func action() -> void:
	if !dialogue.is_finished(): return
	
	# action_open_curtains()
	# spam SPACE (space key is defined in other file) -> to open/close curtains
	if curtains.closed(): curtains.open_full()
	elif curtains.opened(): curtains.close_full()

func hide_pause() -> void:
	var skip: bool = _state == PauseBoxState.DISAPPEARING || _state == PauseBoxState.HIDDEN
	if skip: return
	
	_state = PauseBoxState.DISAPPEARING

# signal linked method
func minigame_block_pause_visual() -> void:
	_minigame_pause_visual_block = true
