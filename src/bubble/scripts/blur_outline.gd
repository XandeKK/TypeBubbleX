class_name BlurOutline
extends ColorRect

var blur_size : int = 0 : get = get_blur_size, set = set_blur_size

func get_blur_size() -> int:
	return blur_size

func set_blur_size(value : int) -> void:
	blur_size = value
	
	material.set_shader_parameter('blur_size', blur_size)

func to_dictionary() -> Dictionary:
	return {
		"blur_size": blur_size
	}

func load(data : Dictionary) -> void:
	blur_size = data['blur_size']
