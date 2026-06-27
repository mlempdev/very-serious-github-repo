extends Node2D

@export var point_light: PointLight2D
@export var darkness: CanvasModulate
@export var visual_timer_anim: AnimationPlayer

@onready var player: Player = $"../Player2"

@onready var hp = 3

@onready var jumpscare: JumpScareController = $Jumpscare
@onready var static_anim: AnimationPlayer = $StaticAnim
@onready var player_starting_pos: Marker2D = $PlayerStartingPos
@onready var timer: Timer = $Timer
@onready var static_screen: TextureRect = $Static
@onready var ambiance_sound_timer: Timer = $AmbianceSoundTimer

var jumpscare_active: bool = false

func _ready() -> void:
	MusicPlayer.play_track(MusicPlayer.SCARY, 0.5, 0.0, -3.0)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	Events.on_minigame_end.connect(func(): visual_timer_anim.stop())
	visual_timer_anim.animation_finished.connect(
		func(anim_name: StringName):
			if anim_name == &"gradual_dim":
				trigger_jumpscare()
			)
	visual_timer_anim.play("gradual_dim")

	_queue_next_ambiance()

func _queue_next_ambiance() -> void:
	ambiance_sound_timer.wait_time = randf_range(6.0, 16.0)
	ambiance_sound_timer.start()

func _on_ambiance_sound_timer_timeout() -> void:
	SoundPool.play_random_sound(SoundPool.SPOOKY_AMBIANCE_ONESHOT)
	_queue_next_ambiance()


func _exit_tree() -> void:
	MusicPlayer.stop_track(2.0)

#func _on_exit_area_body_entered(body: CharacterBody2D) -> void:
	#trigger_jumpscare()
	
func trigger_jumpscare():
	if jumpscare_active:
		return
	
	ambiance_sound_timer.stop()
	jumpscare_active = true
	
	# Disable player and exit area
	player.visible = false

	player.process_mode = Node.PROCESS_MODE_DISABLED
	
	# Disable darkness and trigger jumpscare
	point_light.visible = false
	darkness.visible = false
	 
	# Center jumpscare scene to player and adjust it a bit to cover the whole screen
	# Probably not the best approach lol
	jumpscare.global_position = player.global_position + Vector2(100, 350)
	jumpscare.start_jumpscare()
	SoundPool.play_random_sound(SoundPool.JUMPSCARE_V2)
	
	# Wait till jumpscare is done
	await jumpscare.jumpscare_finished
	jumpscare.voice.stop()
	
	# Static
	static_screen.global_position = player.global_position - (static_screen.size / 2)
	static_anim.play("play_static")
	await static_anim.animation_finished
	
	# Damage
	Events.lose_life.emit()
	if Globals.Lives <= 0:
		return
		
	# Reset player state and level
	player.visible = true
	player.process_mode = Node.PROCESS_MODE_INHERIT
	player.global_position = player_starting_pos.global_position
	
	point_light.show()
	darkness.show()
	static_anim.play("RESET")
	timer.start()
	visual_timer_anim.play("gradual_dim")

	_queue_next_ambiance()

func _on_timer_timeout() -> void: # Hacky fix to prevent jumpscare triggering twice
	jumpscare_active = false
