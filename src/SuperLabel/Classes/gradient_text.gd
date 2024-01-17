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

#func to_dictionary() -> Dictionary:
	#var points : Array = []
	#var gradient : Gradient = get_gradient()
	#for i in gradient.get_point_count():
		#points.append({
			#'offset': gradient.get_offset(i),
			#'color': gradient.get_color(i)
		#})
	#
	#return {
		#'active': active,
		#'points': points,
		#'fill_from': texture_rect.texture.fill_from,
		#'fill_to': texture_rect.texture.fill_to
	#}
#
#func load(value : Dictionary) -> void:
	#active = value['active']
	#
	#var gradient : Gradient = get_gradient()
	#for point in value['points']:
		#gradient.add_point(point['offset'], point['color'])
	#
	texture_rect.texture.fill_from = value['fill_from']
	texture_rect.texture.fill_to = value['fill_to']
