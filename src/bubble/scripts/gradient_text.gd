class_name GradientText
extends TextureRect

var gradient : Gradient

func _ready() -> void:
	gradient = texture.gradient

func get_gradient_texture_2d() -> GradientTexture2D:
	return texture

func to_dictionary() -> Dictionary:
	var points : Array = []
	
	for i in gradient.get_point_count():
		points.append({
			'offset': gradient.get_offset(i),
			'color': gradient.get_color(i)
		})
	
	return {
		'points': points,
		'fill_from': texture.fill_from,
		'fill_to': texture.fill_to
	}

func load(value : Dictionary) -> void:
	for point in range(gradient.get_point_count() - 1, 0, -1):
		gradient.remove_point(point)
	
	for point in value['points']:
		if point == value['points'][0]:
			gradient.set_color(0, point['color'])
			gradient.set_offset(0, point['offset'])
			continue
		
		gradient.add_point(point['offset'], point['color'])
	
	texture.fill_from = value['fill_from']
	texture.fill_to = value['fill_to']
