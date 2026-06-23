extends Node2D

class_name NodeMotionController

var motion: Motion = Motion.new(
				6.0,
				0.4, 0.7,
				0.47,0.62,
				0.032, 0.038,
				0.8, 1.1,
				-0.5, 0.6)

var base_x: float
var base_y: float
var base_scale_x: float
var base_scale_y: float
var base_rotate: float

func _ready() -> void:
	base_x = position.x
	base_y = position.y
	base_scale_x = scale.x
	base_scale_y = scale.y
	base_rotate = rotation

func _process(delta: float) -> void:
	motion.update(delta)
	
	position.x = base_x + motion.offset_x
	position.y = base_y + motion.offset_y
	
	scale.x = base_scale_x + motion.scale
	scale.y = base_scale_y + motion.scale
	
	rotation = base_rotate + motion.rotation
