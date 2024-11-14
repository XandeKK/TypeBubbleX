class_name PerspectiveBubble
extends Control

var bubble : Bubble
var points : Dictionary = {
	'top_left': null,
	'top_right': null,
	'bottom_left': null,
	'bottom_right': null,
}
var default_radius : float = 8
var default_radius_vector2 : Vector2 = Vector2(default_radius, default_radius)
var sub_viewport_perspective : SubViewport

func _init(_bubble : Bubble, _sub_viewport_perspective) -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	
	bubble = _bubble
	sub_viewport_perspective = _sub_viewport_perspective
	
	bubble.add_child(self)
	bubble.resized.connect(_on_resized)
	
	sub_viewport_perspective.size = bubble.size
	_on_resized()

func _exit_tree() -> void:
	for point : Point in points.values():
		if point == null:
			continue
		
		point.free()

func _draw() -> void:
	draw_line(points['top_left'].position + default_radius_vector2, points['top_right'].position + default_radius_vector2, Color.BLUE, 1, true)
	draw_line(points['top_left'].position + default_radius_vector2, points['bottom_left'].position + default_radius_vector2, Color.BLUE, 1, true)
	draw_line(points['bottom_left'].position + default_radius_vector2, points['bottom_right'].position + default_radius_vector2, Color.BLUE, 1, true)
	draw_line(points['top_right'].position + default_radius_vector2, points['bottom_right'].position + default_radius_vector2, Color.BLUE, 1, true)

func _on_resized() -> void:
	size = bubble.size
	reset()

func toggle_visible() -> void:
	visible = not visible

func reset() -> void:
	points['top_left'] = Point.new('top_left', +default_radius_vector2, default_radius, self)
	points['top_right'] = Point.new('top_right', Vector2(bubble.size.x, 0) + default_radius_vector2, default_radius, self)
	points['bottom_left'] = Point.new('bottom_left', Vector2(0, bubble.size.y) + default_radius_vector2, default_radius, self)
	points['bottom_right'] = Point.new('bottom_right', bubble.size + default_radius_vector2, default_radius, self)

func to_dictionary() -> Dictionary:
	var data : Dictionary = {
		'points': {}
	}
	
	for point : Point in points.values():
		data['points'][point.identifier] = point.to_dictionary()
	
	return data

func load(data : Dictionary) -> void:
	points['top_left'].load(data['points']['top_left'])
	points['top_right'].load(data['points']['top_right'])
	points['bottom_left'].load(data['points']['bottom_left'])
	points['bottom_right'].load(data['points']['bottom_right'])

class Point extends Control:
	var identifier : String
	var radius : float
	var original_position : Vector2
	
	var position_initial : Vector2
	var mouse_position_initial: Vector2
	
	var is_dragging : bool
	
	var shader_material : ShaderMaterial
	var parent : PerspectiveBubble
	
	func _init(_identifier : String, _position : Vector2, _radius : float, _parent : PerspectiveBubble) -> void:
		identifier = _identifier
		radius = _radius
		size = Vector2(radius, radius) * 2
		position = _position - size
		original_position = position
		parent = _parent
		
		shader_material = parent.sub_viewport_perspective.texture_rect.material
		parent.add_child(self)

	func _draw() -> void:
		var circle_color = Color.GREEN if is_dragging else Color.PURPLE
		draw_circle(Vector2.ZERO + size / 2, radius, circle_color, true)

	func _gui_input(event: InputEvent) -> void:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			handle_mouse_button_event(event)
		
		if event is InputEventMouseMotion:
			handle_mouse_motion_event(event)
		
		set_mouse_cursor()
		queue_redraw()
		parent.queue_redraw()

	func handle_mouse_button_event(event : InputEventMouseButton) -> void:
		if event.is_pressed():
			if not is_dragging:
				start_dragging(event)

		if is_dragging and not event.is_pressed():
			stop_dragging()

	func start_dragging(event : InputEventMouseButton) -> void:
		is_dragging = true
		position_initial = position
		mouse_position_initial = event.global_position

	func stop_dragging() -> void:
		is_dragging = false

	func handle_mouse_motion_event(event : InputEventMouseMotion) -> void:
		if is_dragging:
			position = event.global_position + position_initial - mouse_position_initial
			set_shader_parameter()
	
	func set_shader_parameter() -> void:
		shader_material.set_shader_parameter(identifier, position - original_position)
	
	func set_mouse_cursor() -> void:
		if is_dragging:
			mouse_default_cursor_shape = Control.CURSOR_MOVE
		else:
			mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	func to_dictionary() -> Dictionary:
		return {
			'identifier': identifier,
			'position': position,
			'original_position': original_position,
			'radius': radius
		}
	
	func load(data : Dictionary) -> void:
		position = data['position']
		original_position = data['original_position']
		radius = data['radius']
		
		set_shader_parameter()
		queue_redraw()
		parent.queue_redraw()
