extends Node2D

enum WHEELSTATE {
	SPINNING,
	MOVING_TO_VALUE,
	IDLE
}

var state: WHEELSTATE = WHEELSTATE.IDLE;
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
var elapsed_spin_time = 0;
var single_value_height_in_texture = 1.0 / items.size();
var value_idx = 2;

func _process(delta: float) -> void:
	if elapsed_spin_time < spin_time:
		speed_multiplier = 1.0 - lerp(
			0,
			1,
			TweenUtils.ease_out_quart(elapsed_spin_time / spin_time)
		);

		elapsed_spin_time += delta

		offset += speed_multiplier;
		offset = fmod(offset, 1.0);
		if (spin_time - elapsed_spin_time < (spin_time * 0.25)):
			if ($WheelSpinEffect.state != $WheelSpinEffect.WheelPEState.SPEED_DOWN_TRANSITION):
				print($WheelSpinEffect.state)
				$WheelSpinEffect.start_slowdown()
			if ($WheelSpinEffect2.state != $WheelSpinEffect2.WheelPEState.SPEED_DOWN_TRANSITION):
				$WheelSpinEffect2.start_slowdown()
	else:
		stop_spinning()

	value_idx = (int((offset + 0.1) / single_value_height_in_texture) + floori(items.size() / 2)) % items.size();

	$WheelTexture.material.set_shader_parameter("offset", offset);
	$WheelValue.text = str(items[value_idx])

func _input(event):
	if event.is_action_pressed("interact"):
		start_spinning()

func start_spinning():
	state = WHEELSTATE.SPINNING
	spin_speed = RandUtils.randf_range(min_speed, max_speed)
	spin_time = RandUtils.randf_range(min_time, max_time)
	elapsed_spin_time = 0

	$WheelSpinEffect.start_speedup()
	$WheelSpinEffect2.start_speedup()
		
func stop_spinning() -> void:
	state = WHEELSTATE.IDLE
	$WheelSpinEffect.start_slowdown()
	$WheelSpinEffect2.start_slowdown()
