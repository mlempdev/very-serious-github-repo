extends Node2D

enum WheelPEState{
	NORMAL_MODE,
	SPEED_UP_TRANSITION,
	SPEED_DOWN_TRANSITION,
	FAST_MODE
}

var state:WheelPEState = WheelPEState.NORMAL_MODE
var normal_speed = 75
var fast_speed = 300
var speed = normal_speed;
var current_speed = 0.0;
var transition_time = 0.0;
var elapsed_time = 0.0;
var min_transition_time = 0.02
var max_transition_time = 0.05
var velocity_diff_multiplier = 2

func update_speed(speed, velocity_diff_multiplier):
	$smallPE.initial_velocity_min = speed
	$smallPE.initial_velocity_max = speed * velocity_diff_multiplier
	$bigPE.initial_velocity_min = speed
	$bigPE.initial_velocity_max = speed * velocity_diff_multiplier

func _process(delta: float) -> void:
	if elapsed_time < transition_time:
		speed = lerp(
			int(current_speed),
			fast_speed if state == WheelPEState.SPEED_UP_TRANSITION else normal_speed,
			elapsed_time / transition_time
		)
		elapsed_time += delta
		update_speed(speed, velocity_diff_multiplier)
	else:
		if state == WheelPEState.SPEED_UP_TRANSITION:
			state = WheelPEState.FAST_MODE
			speed = fast_speed
			update_speed(speed, velocity_diff_multiplier)
		elif state == WheelPEState.SPEED_DOWN_TRANSITION:
			state = WheelPEState.NORMAL_MODE
			speed = normal_speed
			update_speed(speed, velocity_diff_multiplier)
			$bigPE.emitting = false
			$smallPE.emitting = false

func start_speedup():
	current_speed = speed
	state = WheelPEState.SPEED_UP_TRANSITION
	transition_time = RandUtils.randf_range(min_transition_time, max_transition_time)
	elapsed_time = 0.0
	
	$bigPE.emitting = true
	$smallPE.emitting = true

func start_slowdown():
	current_speed = speed
	state = WheelPEState.SPEED_DOWN_TRANSITION
	transition_time = RandUtils.randf_range(min_transition_time, max_transition_time)
	elapsed_time = 0.0

func start_fast_pe_impact() -> void:
	match state:
		WheelPEState.NORMAL_MODE:
			start_speedup()
		WheelPEState.SPEED_DOWN_TRANSITION:
			start_speedup()

func stop_pe_impact() -> void:
	match state:
		WheelPEState.SPEED_UP_TRANSITION:
			start_slowdown()
		WheelPEState.FAST_MODE:
			start_slowdown()
