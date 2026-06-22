extends Area2D

@onready var label = $DisplayControls

var player_in_area = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	# Ensure's keybind label isn't visible at start of scene.
	label.visible = false

func _on_body_entered(body: Node2D):
	player_in_area = true
	# The following code just reads the keybind for "interact" and sets that as the message. 
	var key_names := []
	for event in InputMap.action_get_events("interact"):
		key_names.append(event.as_text())
	label.text = "Press %s to teleport" % " or ".join(key_names)
	label.visible = true
	# not working : speedscale is null. TransitionScene.transition_to("res://assets/scenes/StandardMaze.tscn", 2.0)

func _on_body_exited(body: Node2D):
	# If player leaves the exit area, they cannot change scenes or see keybind.
	player_in_area = false
	label.visible = false

func _process(_delta):
	#if requirements are met, change scene.
	if player_in_area and Input.is_action_just_pressed("interact"):
		Events.change_level("res://assets/scenes/StandardMaze.tscn")
