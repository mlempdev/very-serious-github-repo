# helper function holder class
class_name TweenUtils

static func ease_out_quart(x: float) -> float: # [0, 1]
	return 1.0 - pow(1.0 - x, 4.0)

# Dummy constructor to prevent idiots calling .new()
func _init() -> void:
	assert(false, "Use ConfigExample.target_function() insted")
