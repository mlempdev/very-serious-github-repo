class_name JumpscareAnimationConfig

# todo: decide if params goes into json config -> if animations are not created by multiple tracks then there is no need
# reason: data is still simple to mantain hardcoded in code

#Dummy constructor to prevent idiots calling .new()
func _init() -> void:
	assert(false, "Use RandUtils.target_function() instead")

static var JUMP: RangeTrack = RangeTrack.new("Jump", 0.92, 1.08, true) # somehow lock whis variable - TODO
