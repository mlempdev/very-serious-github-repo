class_name AnimeTrack

func track() -> String:
	return _track

func speed() -> float:
	return _speed

func loop() -> bool:
	return _loop
			
var _track: String
var _speed: float
var _loop: bool

# safe class -> locks editing
func _init(track: String, speed: float, loop: bool) -> void:
	self._track = track
	self._speed = speed
	self._loop = loop
