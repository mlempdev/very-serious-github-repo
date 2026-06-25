extends StaticBody2D

@export var outline_thickness := 2.2

@onready var label: Label = $"Control/Label"
@onready var AnimatedLeverSprite: AnimatedSprite2D = $"AnimatedLever"

signal lever_pulled;

var player_in_area: bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	label.visible = true
	player_in_area = true
	var tween = create_tween()
	tween.tween_property($AnimatedLever.material, "shader_parameter/thickness", outline_thickness, .15)

func _on_area_2d_body_exited(body: Node2D) -> void:
	label.visible = false
	player_in_area = false
	var tween = create_tween()
	tween.tween_property($AnimatedLever.material, "shader_parameter/thickness", 0, .15)

func LeverPulled():
	AnimatedLeverSprite.play("switch_left")
	lever_pulled.emit()

	while AnimatedLeverSprite.is_playing():
		await get_tree().create_timer(0.1).timeout
		if AnimatedLeverSprite.frame_progress == 1:
			AnimatedLeverSprite.play_backwards("switch_left")

func _input(event):
	if event.is_action_pressed("interact") && player_in_area:
		LeverPulled()
