class_name Motion


var time: float
var aggressive: bool = false

# --- tweak ---
var amplitude: float = 6.0
var speed: float = 1.5

var rotation_amount: float = 2.0 # degrees (we convert to radians)
var rotation_speed: float = 1.2

var scale_amount: float = 0.03
var scale_speed: float = 1.0

var min_rotation: float = deg_to_rad(-2.2)
var max_rotation: float = deg_to_rad(2.8)
# --- tweak ---

# --- outputs ---
var offset_x: float
var offset_y: float
var rotation: float
var scale: float
# --- outputs ---

func _init(p_amplitude := 6.0, min_speed := -1.0, max_speed := -1.0,
	p_rotation_amount := 2.0,
	p_rotation_speed := 1.2,
	min_scale := -1.0,
	max_scale := -1.0,
	min_scale_speed := -1.0,
	max_scale_speed := -1.0,
	min_deg := -2.2,
	max_deg := 2.8):
	
	time = randf_range(0.0, 20.0)
	
	if min_speed < 0.0: return
	
	amplitude = p_amplitude
	speed = randf_range(min_speed, max_speed)
	
	rotation_amount = p_rotation_amount
	rotation_speed = p_rotation_speed
	
	scale_amount = randf_range(min_scale, max_scale)
	scale_speed = randf_range(min_scale_speed, max_scale_speed)
	
	min_rotation = deg_to_rad(min_deg)
	max_rotation = deg_to_rad(max_deg)

func update(delta: float) -> void:
	var aggressive_impact := 2.0 if aggressive else 1.0

	time += delta * aggressive_impact

	offset_x = cos(time * speed * 0.7) * (amplitude * 0.5)
	offset_y = sin(time * speed) * amplitude

	var local_rotation = sin(time * rotation_speed) * rotation_amount

	rotation = lerp( min_rotation,  max_rotation, (local_rotation + 1.0) * 0.5 * aggressive_impact)

	scale = sin(time * scale_speed) * scale_amount * aggressive_impact
