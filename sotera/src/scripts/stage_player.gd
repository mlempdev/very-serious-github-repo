extends CharacterBody2D


@export var speed: int = 500

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var footsteps: AudioStreamPlayer2D = $Footsteps
@onready var dust: Node2D = $Dust


func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if direction:
		velocity = direction * speed
		animated_sprite_2d.play("Walk")
		animated_sprite_2d.flip_h = direction.x < 0
		dust._on_player_start_moving()
		if not footsteps.playing:
			footsteps.play()
	else:
		dust._on_player_stop_moving()
		footsteps.stop()
		velocity = Vector2.ZERO
		animated_sprite_2d.play("Idle")

	move_and_slide()
