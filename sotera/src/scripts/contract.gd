extends Node2D

# TODO tell the player they've collected a contract and that now they put back at wheelscene
# TODO make a UI counter so that they can see how many contracts they have

var CanPickUp = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	CanPickUp = true
	# this is placeholder until we sort more out
	Events.change_level("res://assets/scenes/FortuneWheelScene.tscn")

func _on_area_2d_body_exited(body: Node2D) -> void:
	CanPickUp = false
