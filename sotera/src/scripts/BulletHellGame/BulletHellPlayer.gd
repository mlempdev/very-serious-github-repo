extends Player
class_name BulletHellPlayer

@export var gun: BulletHellGun
@export var is_invincible: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animations: AnimatedSprite2D = $Animations

var mousePos: Vector2
var theta = 0
var firing: bool = false

const up_left_theta:float = (-3)*PI/4
const up_right_theta:float = -PI/4
const down_right_theta = PI/4
const down_left_theta = 3*PI/4
const up_theta = -PI/2
const down_theta = PI/2

#Starting screen parameters
func _ready():
	super._ready()
	mousePos = get_global_mouse_position()
	
func idle_animation():
	if theta>down_right_theta && theta<down_left_theta:
		animations.play("forwardidle")
	if theta<up_right_theta&&theta>up_left_theta:
		animations.play("backidle")
	if theta > down_left_theta || theta<up_left_theta:
		animations.play("leftidle")
	if theta < down_right_theta && theta > up_right_theta:
		animations.play("rightidle")
		
func movement_animation():
	if velocity.x == 0 and velocity.y > 0:
		if theta > 0:
			animations.play("forwardrun")
		else:
			animations.play_backwards("backrun")
	elif velocity.x == 0 and velocity.y < 0:
		if theta>0:
			animations.play_backwards("forwardrun")
		else:
			animations.play("backrun")
	elif velocity.x > 0:
		if theta>up_theta && theta<down_theta:
			animations.play("rightrun")
			animations.flip_h = false
		else:
			animations.flip_h = true
			animations.play_backwards("leftrun")
	elif velocity.x < 0:
		if theta>up_theta && theta<down_theta:
			animations.play_backwards("rightrun")
			animations.flip_h = false
		else:
			animations.flip_h = true
			animations.play("leftrun")

func _physics_process(delta):
	mousePos = get_global_mouse_position()
	theta = get_angle_to(mousePos)

	if Input.is_action_just_pressed("action"):
		gun.shoot(mousePos)
	super._physics_process(delta)

func take_damage() -> void:
	if is_invincible:
		return
	Events.lose_life.emit()
	animation_player.play("hurt")

func _on_animations_frame_changed():
	if $Animations.animation in ["forwardrun", "leftrun", "rightrun", "backrun", "forwardrun_reverse", "leftrun_reverse", "rightrun_reverse", "backrun_reverse"]:
		if $Animations.frame in [0, 4]:
			SoundPool.play_sound(SoundPool.PLAYER_FOOTSTEP_STONE)
