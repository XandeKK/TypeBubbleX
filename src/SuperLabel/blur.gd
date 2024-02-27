extends ColorRect

var blur_size : int = 0 : get = _get_blur_size, set = _set_blur_size

func _get_blur_size() -> int:
	return blur_size

func _set_blur_size(value : int) -> void:
	blur_size = value
	material.set_shader_parameter('blur_size', blur_size)

func to_dictionary() -> Dictionary:
	return {
		'blur_size': blur_size,
		'visible': visible
	}

func load(data : Dictionary) -> void:
	blur_size = data['blur_size']
	visible = data['visible']
