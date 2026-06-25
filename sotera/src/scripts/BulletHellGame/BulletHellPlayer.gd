extends CharacterBody2D
class_name BulletHellCharacter

@export var speed: float = 500
@export var gun: BulletHellGun
@export var iFrames: int
@export var maxHp: int

@onready var hp = maxHp
@onready var animations: AnimatedSprite2D = $Animations
@onready var footsteps: AudioStreamPlayer2D = $Footsteps

var currentiFrames: int = 0
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
	animations.play("forwardidle")
	mousePos = get_viewport().get_mouse_position()
	
func player_movement():
#player movement
	var direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	velocity = direction * speed
	
	
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
			animations.play("backrun_reverse")
	elif velocity.x == 0 and velocity.y < 0:
		if theta>0:
			animations.play("forwardrun_reverse")
		else:
			animations.play("backrun")
	elif velocity.x > 0:
		if theta>up_theta && theta<down_theta:
			animations.play("rightrun")
			animations.flip_h = false
		else:
			animations.flip_h = true
			animations.play("leftrun_reverse")
	elif velocity.x < 0:
		if theta>up_theta && theta<down_theta:
			animations.play("rightrun_reverse")
			animations.flip_h = false
		else:
			animations.flip_h = true
			animations.play("leftrun")

func _physics_process(_delta):
	if currentiFrames > 0:
		currentiFrames -= 1

	mousePos = get_global_mouse_position()
	theta = get_angle_to(mousePos)

	if Input.is_action_just_pressed("action"):
		gun.shoot(mousePos)
	player_movement()
	
	#player animations
	if velocity == Vector2.ZERO:
		idle_animation()

	else:
		movement_animation()
		
	move_and_slide()

#frame perfect / footsteps
func _on_animations_frame_changed():
	if $Animations.animation in ["forwardrun", "leftrun", "rightrun", "backrun"]:
		if $Animations.frame in [0, 4]:
			SoundPool.play_random_shuffled_sound(SoundPool.PLAYER_FOOTSTEPS) # TODO: if time, make custom footstep groups for each scene

		
func takeDamage(damage:int) -> void:
	if currentiFrames <= 0:
		currentiFrames = iFrames
		hp -= damage
		Events.loose_life.emit()
		
	if hp <= 0:
		#Minigame over
		print("Player Dead")
		takeDamage(0) #crashing the game on death for funsies	
	
