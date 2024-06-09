extends Path2D
class_name TextPath2D

var text : Text : set = set_text
var size : Vector2 : set = set_size
var can_draw : bool = false : set = set_can_draw
var active : bool = false : set = set_active
var curve_original : Curve2D

var current_point_position : int = -1
var current_point_in : int = -1
var current_point_out : int = -1
var click_radius : int = 5
var dragging : bool = false

func _ready():
	set_process_input(false)

func _draw():
	if not can_draw:
		return
	if not active:
		return
	
	draw_polyline(curve.get_baked_points(), Color.AQUA, 1, true)
	
	for i in range(curve.point_count):
		var point_position : Vector2 = curve.get_point_position(i)
		var point_in : Vector2 = curve.get_point_in(i)
		var point_out : Vector2 = curve.get_point_out(i)
		
		draw_line(point_position, point_out + point_position, Color.REBECCA_PURPLE, 1, true)
		draw_line(point_position, point_in + point_position, Color.REBECCA_PURPLE, 1, true)
		draw_circle(point_position, 5, Color.RED)
		draw_circle(point_in + point_position, 5, Color.RED)
		draw_circle(point_out + point_position, 5, Color.RED)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		for i in range(curve.point_count):
			if not dragging and event.pressed:
				var _position : Vector2 = curve.get_point_position(i)
				var _position_in : Vector2 = curve.get_point_in(i)
				var _position_out : Vector2 = curve.get_point_out(i)
				var mouse_position : Vector2 = get_local_mouse_position()
			
				if (mouse_position - _position).length() < click_radius:
					dragging = true
					current_point_position = i
				elif (mouse_position - (_position + _position_in)).length() < click_radius:
					dragging = true
					current_point_in = i
				elif (mouse_position - (_position + _position_out)).length() < click_radius:
					dragging = true
					current_point_out = i
		
		if dragging and not event.pressed:
			dragging = false
			current_point_position = -1
			current_point_in = -1
			current_point_out = -1

	if event is InputEventMouseMotion and dragging:
		var mouse_position : Vector2 = get_local_mouse_position()
		if current_point_position != -1:
			curve.set_point_position(current_point_position, mouse_position)
			draw_()
		elif current_point_in != -1:
			var _position = curve.get_point_position(current_point_in)
			curve.set_point_in(current_point_in, mouse_position - _position)
			curve.set_point_out(current_point_in, -(mouse_position - _position))
			draw_()
		elif current_point_out != -1:
			var _position = curve.get_point_position(current_point_out)
			curve.set_point_out(current_point_out, mouse_position - _position)
			curve.set_point_in(current_point_out, -(mouse_position - _position))
			draw_()

func set_text(value : Text) -> void:
	text = value
	text.text_path = self

func set_size(value : Vector2) -> void:
	size = value
	
	curve.clear_points()

	curve.add_point(Vector2(0, size.y / 2))
	curve.add_point(Vector2(size.x, size.y / 2))
	curve_original = curve.duplicate()
	curve.add_point(Vector2(size.x/2, size.y/2), Vector2(-50, 0), Vector2(50, 0), 1)

func reset() -> void:
	curve.clear_points()

	curve.add_point(Vector2(0, size.y / 2))
	curve.add_point(Vector2(size.x, size.y / 2))
	curve.add_point(Vector2(size.x/2, size.y/2), Vector2(-50, 0), Vector2(50, 0), 1)
	draw_()

func set_can_draw(value : bool) -> void:
	can_draw = value
	queue_redraw()

func set_active(value : bool) -> void:
	active = value
	can_draw = value
	set_process_input(active)
	queue_redraw()

func draw_() -> void:
	queue_redraw()
	text.render_()

func get_points() -> Array:
	var points : Array = []
	
	for i in range(curve.point_count):
		points.append({
			'position': curve.get_point_position(i),
			'in': curve.get_point_in(i),
			'out': curve.get_point_out(i)
		})
	
	return points

func to_dictionary() -> Dictionary:
	return {
		'active': active,
		'points': get_points()
	}

func load(data : Dictionary) -> void:
	curve.clear_points()
	
	active = data['active']
	
	for point in data['points']:
		curve.add_point(point.position, point.in, point.out)
	
	draw_()
