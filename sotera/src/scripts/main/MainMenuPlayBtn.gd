extends MainMenuBtn
class_name MainMenuPlayBtn

@export var root: MenuRoot
@export var game_over_cover_texture: TextureRect

func _ready() -> void:
	super._ready()
	if game_over_cover_texture != null: # check is here because Welcome cache - wait to remove button
		game_over_cover_texture.visible = Globals.gameover

func _on_click() -> void:
	super._on_click()
	curtain_system.open_full()
	root._on_play_pressed()
	SoundPool.play_sound(SoundPool.UI_PLAY)
