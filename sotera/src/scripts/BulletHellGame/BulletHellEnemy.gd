extends CharacterBody2D
class_name BulletHellEnemy

#@export var meleeRange:float
@export var melee: Node2D
@export var navAgent: NavigationAgent2D
@export var movementSpeed: float = 200.0
@export var maxHp: int
@export var damage: int

@onready var animations: AnimatedSprite2D = $Animations
@onready var hp = maxHp

var player: Player
var spawnPos: Vector2
var damagingPlayer = false
var state: BHENEMYSTATE = BHENEMYSTATE.DISABLED

signal enemyKilled(enemy:BulletHellEnemy)

enum BHENEMYSTATE{
	DISABLED,
	MOVING,
	ATTACKING
}

func _ready() -> void:
	#navAgent.set_target_desired_distance(m)
	animations.play("idle_down")
	actor_setup.call_deferred()

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	if player:
		set_movement_target(player.position)
	else: 
		print("player_mising")
func set_movement_target(movement_target: Vector2):
	navAgent.target_position = movement_target


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if state !=BHENEMYSTATE.DISABLED:
		set_movement_target(player.position)
	match state:
		BHENEMYSTATE.ATTACKING:
			velocity = Vector2.ZERO
			if damagingPlayer:
				player.take_damage()
		BHENEMYSTATE.DISABLED:
			velocity = Vector2.ZERO
		BHENEMYSTATE.MOVING:
			if navAgent.is_target_reached():
				return
			
			var currentAgentPosition: Vector2 = global_position
			var nextPathPosition: Vector2 = navAgent.get_next_path_position()
			navAgent.set_velocity( currentAgentPosition.direction_to(nextPathPosition) * movementSpeed)
			melee.look_at(global_position+velocity)
			movement_animation()
			
	move_and_slide()
	
func movement_animation():
	if absf(velocity.x)<absf(velocity.y):
		
		
		if velocity.y > 0:
			animations.play("walk_down")
		elif velocity.y < 0:
			animations.play("walk_up")
	else:
		if velocity.x > 0:
			animations.flip_h = false
			animations.play("walk_right")
		elif velocity.x < 0:
			animations.flip_h = true
			animations.play("walk_right")

func spawn(spawnPos:Vector2,player:BulletHellPlayer)->void:
	state = BHENEMYSTATE.MOVING
	self.spawnPos = spawnPos
	position = spawnPos
	self.player = player
	hp = maxHp
	$Animations.show()
	pass
	
func takeDamage(damageToTake:int)->void:
	hp -= damageToTake
	SoundPool.play_random_sound(SoundPool.KNIFE_STAB)
	if hp<=0:
		destroy()
		SoundPool.play_random_shuffled_sound(SoundPool.ZOMBIE_GROWL)
	pass

func isDisabled() -> bool:
	return state == BHENEMYSTATE.DISABLED
	
func destroy()->void:
	if !isDisabled():
		state = BHENEMYSTATE.DISABLED
		emit_signal("enemyKilled",self)
		position = spawnPos
		
		$Animations.hide()

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body is BulletHellPlayer:
		if state == BHENEMYSTATE.MOVING:
			state = BHENEMYSTATE.ATTACKING
			damagingPlayer = true
			SoundPool.play_sound(SoundPool.ZOMBIE_BITE)
			SoundPool.play_random_sound(SoundPool.AUDIENCE_LAUGH)
			


func _on_attack_hitbox_body_exited(body: Node2D) -> void:
	if body is BulletHellPlayer:
		if state==BHENEMYSTATE.ATTACKING:
			damagingPlayer = false
			state = BHENEMYSTATE.MOVING
		

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.get_parent():
		var parent = area.get_parent()
		if parent is BulletHellBullet:
			takeDamage(parent.damage)
			parent.disable()


func _on_navigation_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
