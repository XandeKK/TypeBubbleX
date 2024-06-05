extends Control
class_name Brush

@onready var texture_rect : TextureRect = get_parent()

var radius : int = 10
var alpha : float = 0.0
var last_mouse_position : Vector2 = Vector2(-1, -1)
var is_drawing : bool = false

func _ready():
	set_process_input(false)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_drawing =  true
		else:
			is_drawing =  false
			last_mouse_position = Vector2(-1,-1)
	if event is InputEventMouseMotion and is_drawing:
		var mouse_position : Vector2 = get_local_mouse_position()
		
		if last_mouse_position.x >= 0 and last_mouse_position.y >= 0:
			var distance = mouse_position.distance_to(last_mouse_position)
			var steps = int(distance)
			
			for i in range(steps):
				var interpolated_position = last_mouse_position.lerp(mouse_position, float(i) / steps)
				_draw_circle(interpolated_position)

		last_mouse_position = mouse_position

		_draw_circle(mouse_position)
		
		texture_rect.texture.update(texture_rect.image)

func _draw_circle(center: Vector2):
	for x in range(-radius, radius + 1):
		for y in range(-radius, radius + 1):
			if x * x + y * y <= radius * radius:
				var pixel_position = center + Vector2(x, y)
				if pixel_position.x >= 0 and pixel_position.x < texture_rect.image.get_width() and pixel_position.y >= 0 and pixel_position.y < texture_rect.image.get_height():
					texture_rect.image.set_pixelv(pixel_position, Color(0.0, 0.0, 0.0, alpha))
