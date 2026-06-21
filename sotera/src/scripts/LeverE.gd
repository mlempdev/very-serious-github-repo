extends Sprite2D

var is_button_visible : bool = false

enum buttonstate{
	APPEAR,
	HIDE,
	IDLE,
	PRESSING_DOWN,
	GOING_UP
}

var currentbuttonstate : buttonstate = buttonstate.HIDE

@export var target_lever: Node2D

#Base Values
var base_scale : Vector2 = Vector2.ONE
var base_offset : Vector2 = Vector2(40,-40)
var base_rotation : float = 0.0

var motion_time : float = 0.0

func _ready() -> void:
	#Start Completely invisible
	modulate.a = 0.0
	scale = Vector2.ZERO
	
func _process(delta: float) -> void:
	if currentbuttonstate == buttonstate.IDLE:
		_apply_idle_motion(delta)

#Idle Motion
func _apply_idle_motion(delta : float) -> void:
	motion_time += delta * 1.5
	
	#Using Sin/Cos for effects
	var motion_scale = Vector2(sin(motion_time) * 0.05, cos(motion_time) * 0.05)
	var motion_offset =Vector2(sin(motion_time * 0.08) * 3.0, cos(motion_time * 0.08) * 3.0)
	
	scale = base_scale + motion_scale
	offset = base_offset + motion_offset
	
#Visibility & Hide Logic
func on_player_in_sensor_area(in_area : bool , player_is_left: bool) -> void:
		is_button_visible = in_area
		
		if in_area and currentbuttonstate == buttonstate.HIDE:
			_start_appear(player_is_left)
		elif not in_area and currentbuttonstate != buttonstate.HIDE:
			_start_hide()
			
		if in_area and currentbuttonstate == buttonstate.IDLE:
			_update_avoidance_position(player_is_left)
			
func _update_avoidance_position(player_is_left : bool) -> void:
	var target_offset = Vector2(40,-40) if player_is_left else Vector2(-40,-40)
	
	if base_offset != target_offset:
		base_offset = target_offset
		var tween = create_tween()
		tween.tween_property(self,"offset",base_offset,randf_range(0.3 , 0.6))
		
func _start_appear(player_is_left: bool) -> void:
	currentbuttonstate = buttonstate.APPEAR
	base_offset = Vector2(40,-40) if player_is_left else Vector2(-40,-40)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self,"scale",base_scale,0.4)
	tween.tween_property(self,"modulate:a",1.0,0.4)
	tween.chain().tween_callback(func(): currentbuttonstate = buttonstate.IDLE)
	
func _start_hide() -> void:
	currentbuttonstate = buttonstate.HIDE
	
	#Interpolation based on the random time
	var hide_time = randf_range(0.3,0.6)
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self,"scale",Vector2.ZERO,hide_time)
	tween.tween_property(self,"modulate:a",0.0,hide_time)
	tween.chain().tween_callback(_on_hide_finish)
	
func _on_hide_finish() -> void:
	currentbuttonstate = buttonstate.HIDE
	
#Pressing Up and Down Animation

func start_pressing() -> void:
	if currentbuttonstate != buttonstate.IDLE:
		return
	
	currentbuttonstate = buttonstate.PRESSING_DOWN
	var press_time = randf_range(0.1,0.3)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self,"scale",base_scale * 0.7,press_time)
	tween.tween_property(self,"modulate:a",0.5,press_time)
	tween.chain().tween_callback(_on_press_completed)
	
func _on_press_completed() -> void:
	if target_lever:
			target_lever.on_start_pulling()	
			
	_start_going_up()		
						
	

func _start_going_up() -> void:
	currentbuttonstate	= buttonstate.GOING_UP
	var up_time = randf_range(0.1,0.3)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self,"scale",base_scale,up_time)
	tween.tween_property(self,"modulate:a",1.0,up_time)
	tween.chain().tween_callback(func(): currentbuttonstate = buttonstate.IDLE)
			
	   	
