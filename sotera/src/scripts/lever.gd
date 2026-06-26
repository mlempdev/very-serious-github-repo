extends StaticBody2D

@export var outline_thickness := 2.2

@onready var label: Label = $"Control/Label"
@onready var lever_sprite_animation: AnimatedSprite2D = $"AnimatedLever"

signal lever_pulled;

var player_in_area: bool = false
var player_can_pull = false # todo change later

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !player_can_pull: return

	label.visible = true
	player_in_area = true
	var tween = create_tween()
	tween.tween_property(lever_sprite_animation.material, "shader_parameter/thickness", outline_thickness, .15)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if !player_can_pull: return
	
	label.visible = false
	player_in_area = false
	var tween = create_tween()
	tween.tween_property(lever_sprite_animation.material, "shader_parameter/thickness", 0, .15)

func _pull() -> void:
	lever_sprite_animation.play("switch_left")
	lever_pulled.emit()

	while lever_sprite_animation.is_playing():
		await get_tree().create_timer(0.1).timeout
		if lever_sprite_animation.frame_progress == 1:
			lever_sprite_animation.play_backwards("switch_left")

func _input(e: InputEvent) -> void:
	var is_action_pull: bool = e.is_action_pressed("interact") && player_in_area && player_can_pull
	if is_action_pull: _pull()

func _on_dialogue_text_speech_ended() -> void:
	player_can_pull = true
