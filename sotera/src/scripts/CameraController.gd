extends Camera2D

var motion: CameraMotion = CameraMotion.new()

# Base Params
var base_zoom: Vector2
var base_offset: Vector2
var base_rotation: float

#Change the flag values as per the required testing ie for only scale(true,false,false) ,scale and offset(true,true,false)
@export var test_scale: bool = true
@export var test_offset: bool = true
@export var test_rotation: bool = true

func _ready() -> void:
	base_zoom = zoom
	base_offset = offset
	base_rotation = rotation

	
	motion.enable_scale = test_scale
	motion.enable_offset = test_offset
	motion.enable_rotation = test_rotation

func _process(delta: float) -> void:
	var motion_params = motion.get_motion(delta)

	zoom = base_zoom + motion_params["scale"]
	offset = base_offset + motion_params["offset"]
	rotation = base_rotation + motion_params["rotation"]
