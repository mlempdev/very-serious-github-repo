# helper function holder class
# create new class -> this is only an example
class_name ConfigExample

# Dummy constructor to prevent idiots calling .new()
func _init() -> void:
	assert(false, "Use ConfigExample.target_function() insted")

const MAIN_CHARACTER_ANIMATION_EXAMPLE_IDLE_TAG: String = "example animation name"
const MAIN_CHARACTER_ANIMATION_EXAMPLE_RUN_TAG: String = "example animation name"
const MAIN_CHARACTER_ANIMATION_EXAMPLE_HIT_TAG: String = "example animation name"
const MAIN_CHARACTER_ANIMATION_EXAMPLE_WALK_TAG: String = "example animation name"
