extends Node

class_name AssetsUtils

#Dummy constructor to prevent idiots calling .new()
func _init() -> void:
	assert(false, "Use RandUtils.target_function() instead")
	
static func parse_array_json_res(path: String) -> Array:
	var text = FileAccess.get_file_as_string(path)
	
	var data = JSON.parse_string(text)
	
	if data == null:
		push_error("Invalid JSON Array!")
		return []
		
	return data
