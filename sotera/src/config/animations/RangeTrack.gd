class_name RangeTrack

func track() -> String:
	return _track

func min_speed() -> float:
	return _min_speed
	
func max_speed() -> float:
	return _max_speed

func loop() -> bool:
	return _loop
			
var _track: String
var _min_speed: float
var _max_speed: float
var _loop: bool

# safe class -> locks editing
func _init(track: String, min_speed: float, max_speed: float, loop: bool) -> void:
	self._track = track
	self._min_speed = min_speed
	self._max_speed = max_speed
	self._loop = loop
