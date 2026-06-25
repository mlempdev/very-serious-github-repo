extends Node2D

@export var point_light: PointLight2D
@export var darkness: CanvasModulate
@export var player: CharacterBody2D

@onready var hp = 3

@onready var jumpscare: JumpScareController = $Jumpscare
@onready var static_anim: AnimationPlayer = $StaticAnim

var jumpscare_triggered: bool = false

func _on_wall_area_body_entered(body: Node2D) -> void:
	# Player takes damage from walls
	hp -= 1
	if hp == 0:
		# Change to game over scene
		get_tree().change_scene_to_file("res://assets/scenes/FortuneWheelScene.tscn")

func _on_exit_area_body_entered(body: CharacterBody2D) -> void:
	if jumpscare_triggered:
		return
		
	jumpscare_triggered = true
	
	# Disable player and exit area
	player.visible = false
	player.process_mode = Node.PROCESS_MODE_DISABLED
	player.get_node("Footsteps").stop()
	
	# Disable darkness and trigger jumpscare
	point_light.visible = false
	darkness.visible = false
	jumpscare.start_jumpscare()
	
	# Wait till jumpscare is done
	await jumpscare.jumpscare_finished
	jumpscare.voice.stop()
	
	# Static
	static_anim.play("play_static")
	await static_anim.animation_finished
	
	# Reset player state and go back to wheel
	player.visible = true
	player.process_mode = Node.PROCESS_MODE_INHERIT
	get_tree().call_deferred("change_scene_to_file", "res://assets/scenes/FortuneWheelScene.tscn")
