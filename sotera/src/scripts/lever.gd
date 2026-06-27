extends StaticBody2D

@export var outline_thickness := 2.2

@onready var label: Label = $"Control/Label"
@onready var lever_sprite_animation: AnimatedSprite2D = $"AnimatedLever"

signal lever_pulled;

var player_in_area: bool = false
var _pullable: bool = true # disabled at start because text dialogue
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	label.visible = true
	player_in_area = true
	var tween = create_tween()
	tween.tween_property(lever_sprite_animation.material, "shader_parameter/thickness", outline_thickness, .15)

func _on_area_2d_body_exited(body: Node2D) -> void:
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

func _process(_delta: float) -> void:
	if Input.is_action_pressed("interact") && player_in_area && _pullable:
		_pull()

func enable() -> void:
	_pullable = true
	
func disable() -> void:
	_pullable = false
