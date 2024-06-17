extends ColorRect
class_name MotionBlur

var blur_amount : int = 16 : set = set_blur_amount, get = get_blur_amount
var blur_direction_x : float = 0 : set = set_blur_direction_x, get = get_blur_direction_x
var blur_direction_y : float = 0 : set = set_blur_direction_y, get = get_blur_direction_y

func set_blur_amount(value : int) -> void:
	blur_amount = value
	material.set_shader_parameter('blur_amount', blur_amount)

func get_blur_amount() -> int:
	return blur_amount

func set_blur_direction_x(value : float) -> void:
	blur_direction_x = value
	material.set_shader_parameter('blur_direction', Vector2(blur_direction_x, blur_direction_y))

func get_blur_direction_x() -> float:
	return blur_direction_x

func set_blur_direction_y(value : float) -> void:
	blur_direction_y = value
	material.set_shader_parameter('blur_direction', Vector2(blur_direction_x, blur_direction_y))

func get_blur_direction_y() -> float:
	return blur_direction_y

func to_dictionary() -> Dictionary:
	return {
		"blur_amount": blur_amount,
		"blur_direction_x": blur_direction_x,
		"blur_direction_y": blur_direction_y
	}

func load(data : Dictionary) -> void:
	blur_amount = data['blur_amount']
	blur_direction_x = data['blur_direction_x']
	blur_direction_y = data['blur_direction_y']
