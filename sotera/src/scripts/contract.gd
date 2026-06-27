extends Node2D

var can_collect = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	can_collect = true
	$Label.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	can_collect = false
	$Label.hide()

func _collect_contract():
	Events.on_minigame_end.emit()
	SoundPool.play_sound(SoundPool.UI_PICKUP)
	SoundPool.play_sound(SoundPool.CONTRACT_PICKUP)
	Events.change_level("res://assets/scenes/FortuneWheelScene.tscn")

func _process(_delta: float) -> void:
	if Input.is_action_pressed("interact") && can_collect:
		_collect_contract()
		can_collect = false
