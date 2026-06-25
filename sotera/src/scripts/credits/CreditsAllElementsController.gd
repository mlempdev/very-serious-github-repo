extends VBoxContainer

class_name CreditsAllElementsController

enum CreditsState{ DELAY, ROLLING }


# -------- state params --------
@export var range_delay_time_before_scroll: Vector2 = Vector2(2.0, 4.0)
var _state: CreditsState = CreditsState.DELAY
var _delay_time: float
var _max_delay_time: float
# -------- state params --------


# ----------- auto scrolling params -------------
@onready var _scroll_holder: ScrollContainer = get_parent()
@export var range_auto_scroll_speed: Vector2 = Vector2(2.0, 2.0)
var padding_top: float # limit
var _scroll_speed: float
var _max_scroll_y: float
var _scroll_y: float = 0.0
# ----------- auto scrolling params -------------


# on scene enter
func _ready() -> void:
	_delay_time = 0.0
	_max_delay_time = randf_range(range_delay_time_before_scroll.x, range_delay_time_before_scroll.y)
	_scroll_speed = randf_range(range_auto_scroll_speed.x, range_auto_scroll_speed.y)
	
	var screen_height = get_viewport().get_visible_rect().size.y
	var control_height = _scroll_holder.size.y
	
	var credits_title: Label = $"Credits Title"
	padding_top = (screen_height) * 0.5 # - credits_title.size.y) * 0.5
	var padding_bot: float = 120
	
	var bar = _scroll_holder.get_v_scroll_bar()
	
	# bar.value_changed.connect(_on_scroll) # link funcion on_scroll_changed
	
	bar.min_value = -padding_top
	_max_scroll_y = size.y + padding_top + padding_bot
	bar.max_value = _max_scroll_y
	_scroll_y = bar.min_value

	_scroll_holder.scroll_vertical = int(bar.min_value) # adjust to scroll be on credits title
	
	
func _update_delay(delta: float) -> void:
	_delay_time = min(_delay_time + delta, _max_delay_time)
	if _delay_time == _max_delay_time:
		_state = CreditsState.ROLLING

func _update_rolling(delta: float) -> void:
	_scroll_y = min(_scroll_y + _scroll_speed * delta, _max_scroll_y)
	_scroll_holder.scroll_vertical = int(_scroll_y) #min(_scroll_holder.scroll_vertical + _scroll_speed * delta, _max_scroll_y)

func _gui_input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_on_scroll()
			
func _on_scroll() -> void:
	_delay_time = 0.0
	_scroll_y = _scroll_holder.scroll_vertical
	_state = CreditsState.DELAY
	
	
	
func _process(delta: float) -> void:
	match _state:
		CreditsState.DELAY: _update_delay(delta)
		CreditsState.ROLLING: _update_rolling(delta)
		
	# _auto_detect_scrolling()
	
