class_name JumpscareConfig

#Dummy constructor to prevent idiots calling .new()
func _init() -> void:
	assert(false, "Use RandUtils.target_function() instead")

# All ranges in pairs for RNG/Rand
const MIN_STARTING_SILENCE_SEC: float = 2.15
const MAX_STARTING_SILENCE_SEC: float = 3.72

const MIN_LURE_VOLUME_DB: float = -18.4
const MAX_LURE_VOLUME_DB: float = -21.2

const MIN_START_OF_PROMISIED_DB: float = -2.5
const MAX_START_OF_PROMISIED_DB: float = 1.7

const MIN_END_OF_PROMISIED_DB: float = 22.5
const MAX_END_OF_PROMISIED_DB: float = 24.0

# scale
const MIN_STARTING_SPRITE_JUMP_SCALE: float = 1.0
const MAX_STARTING_SPRITE_JUMP_SCALE: float = 1.05
const MIN_END_SPRITE_JUMP_SCALE: float = 1.3
const MAX_END_SPRITE_JUMP_SCALE: float = 1.42

# rotation
const MIN_STARTING_SPRITE_JUMP_ROTATION_DEG: float = -6.5
const MAX_STARTING_SPRITE_JUMP_ROTATION_DEG: float = 7.2
const MIN_END_SPRITE_JUMP_ROTATION_DEG: float = -12.5
const MAX_END_SPRITE_JUMP_ROTATION_DEG: float = 13.2

# fixed (no rng) params
const START_PROMISE_SEC: float = 3.01 # checked from Audocity ... based on voice acting file <voices calling player.wav>
const MAX_VOICE_RECORDING_TIME_SEC: float = 6.0 - START_PROMISE_SEC # max length of voice ... coded -> <voice file> does not control anything
