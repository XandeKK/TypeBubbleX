class_name BlurBubble
extends Object

var material : ShaderMaterial
var bubble : Bubble
var sub_viewport_blur : SubViewport

var blur_size : int = 0 : get = get_blur_size, set = set_blur_size

func _init(_bubble : Bubble, _sub_viewport_blur) -> void:
	bubble = _bubble
	sub_viewport_blur = _sub_viewport_blur
	material = sub_viewport_blur.color_rect.material
	
	sub_viewport_blur.size = bubble.size

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
