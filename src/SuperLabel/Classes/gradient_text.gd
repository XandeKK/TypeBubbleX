extends Node
class_name GradientText

var letters : Control : set = _set_letters

var texture_rect : TextureRect

var active : bool = false : set = _set_active

func get_gradient() -> Gradient:
	return texture_rect.texture.gradient

func get_gradient_texture_2d() -> GradientTexture2D:
	return texture_rect.texture

func _set_letters(value : Control) -> void:
	letters = value
	
	texture_rect = letters.get_child(0)

func _set_active(value : bool) -> void:
	active = value
	
	texture_rect.visible = active
