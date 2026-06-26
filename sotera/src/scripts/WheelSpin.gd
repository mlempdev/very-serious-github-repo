extends Node2D

enum WheelState {
	SPINNING, # goes to WAIT_CURTAINS_TO_CLOSE
	COMPLETE, # We'll allow spinning only once
	IDLE,
	WAIT_CURTAINS_TO_CLOSE
}

var _state: WheelState = WheelState.IDLE;
var offset: float = 0.0;
var spin_speed: float = 0.0;
var spin_time: float = 0.0;
var min_speed: float = 0.1;
var max_speed: float = 0.2;
var min_time: float = 3.0;
var max_time: float = 5.0;

var speed_multiplier: float = 0.0;

var items: Array[String] = [
	"maze", "bullet", "scary", "quiz", "story"
]
var itemSceneMap: Dictionary[String, String] = {
	"maze": "res://assets/scenes/StandardMaze.tscn",
	"bullet": "res://assets/scenes/BulletHellMinigame.tscn",
	"scary": "res://assets/scenes/ScaryMaze.tscn"
}

var elapsed_spin_time: float = 0.0;
var single_value_height_in_texture: float = 1.0 / items.size();
var value_idx: int = 2;

@export var curtains: CurtainSystem
@export var minigame_tracker: MiniGameTracker

@onready var effect1: Node2D = $WheelSpinEffect
@onready var effect2: Node2D = $WheelSpinEffect2
@onready var wheel_material: Material = $WheelTexture.material
@onready var wheel_value: Label = $WheelValue

func _ready() -> void:
	offset = Events.get_spinner_start_offset()

func _process(delta: float) -> void:
	match _state:
		WheelState.IDLE: return
		WheelState.WAIT_CURTAINS_TO_CLOSE: check_if_curtains_are_closed()
		WheelState.SPINNING: update_spin(delta)


func update_spin(delta: float) -> void:
	if elapsed_spin_time < spin_time:
		speed_multiplier = 1.0 - lerp(
			0,
			1,
			TweenUtils.ease_out_quart(elapsed_spin_time / spin_time)
		);

		elapsed_spin_time += delta

		offset += speed_multiplier;
		offset = fmod(offset, 1.0);
		if(spin_time - elapsed_spin_time < (spin_time * 0.25)):
			if(effect1.state != effect1.WheelPEState.SPEED_DOWN_TRANSITION): effect1.stop_pe_impact()
			if(effect2.state != effect2.WheelPEState.SPEED_DOWN_TRANSITION): effect2.stop_pe_impact()
			
	else: _stop()

	value_idx = (int((offset + 0.1) / single_value_height_in_texture) + floori(items.size() / 2)) % items.size();

	wheel_material.set_shader_parameter("offset", offset);
	wheel_value.text = str(items[value_idx])

func start_spinning() -> void:
	if _state != WheelState.IDLE: return # IDLE -> SPINNING
	
	_state = WheelState.SPINNING
	spin_speed = min_speed # RandUtils.randf_range(min_speed, max_speed)
	spin_time = min_time # RandUtils.randf_range(min_time, max_time)
	elapsed_spin_time = 0

	SoundPool.play_sound(SoundPool.WHEEL_START)

	effect1.start_speedup()
	effect2.start_speedup()
	
	await get_tree().create_timer(spin_time * 0.45).timeout
	
	SoundPool.play_sound(SoundPool.WHEEL_STOP)

func check_if_curtains_are_closed() -> void:
	if !curtains.closed(): return
	
	SoundPool.play_sound(SoundPool.MINIGAME_SELECTED)
	Events.change_level(itemSceneMap[str(items[value_idx])])
	
	_state = WheelState.COMPLETE
	
func _stop() -> void:
	var winning_game = items[value_idx]
	
	if minigame_tracker:
		minigame_tracker.add_minigame(winning_game)
		
	start_closing_curtains()	


		
func start_closing_curtains() -> void:
	# PROCEDURE:
	# 1 ... start closing curtains
	# 2 ... curtains == closed -> start_mini_game()
	
	_state = WheelState.WAIT_CURTAINS_TO_CLOSE
	
	Events.increase_spinner_starting_positoin()
	effect1.start_slowdown()
	effect2.start_slowdown()
	curtains.close_full()
	
	SoundPool.stop_sound(SoundPool.AUDIENCE_CHEER, 5.0)

func _on_lever_lever_pulled() -> void:
	start_spinning()
	SoundPool.play_sound(SoundPool.LEVER_PULL)
	SoundPool.play_sound(SoundPool.AUDIENCE_CHEER)
