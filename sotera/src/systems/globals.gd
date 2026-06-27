extends Node

# TODO: replace with GameManager
# TODO: use game manager as <context data> only (no functions)

var Total_contracts: int = 0
var Lives: int = 4
var lever_auto_enable: bool = false
var gameover: bool = false

func _ready() -> void:
	Events.on_minigame_end.connect(increment_contracts)
	Events.lose_life.connect(take_damage)

func take_damage() -> void:
	Lives -= 1
	if Lives == 0:
		gameover = true
		SoundPool.play_sound(SoundPool.MINIGAME_FAIL)
		Events.change_level("res://assets/scenes/FortuneWheelScene.tscn")

func increment_contracts() -> void:
	Total_contracts += 1 # increment_contracts
