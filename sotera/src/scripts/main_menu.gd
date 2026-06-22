extends Control

@export var target_scene: String

func _on_play_pressed() -> void:
	Events.change_level(target_scene)

func _on_volume_slider_value_changed(value: float) -> void:
	# set master volume using scroll
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
