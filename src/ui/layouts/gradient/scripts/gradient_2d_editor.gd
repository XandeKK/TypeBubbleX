class_name Gradient2DEditor
extends Control

var gradient_texture_2d : GradientTexture2D : set = _set_gradient_texture_2d
var from_point : Point
var to_point : Point
var editable : bool = true : set = _set_editable

func _ready() -> void:
	from_point = Point.new(self, false)
	to_point = Point.new(self, true)

	add_child(from_point)
	add_child(to_point)

func _exit_tree() -> void:
	from_point.queue_free()
	to_point.queue_free()

func _draw() -> void:
	if gradient_texture_2d == null:
		return
	
	var rect : Rect2 = get_rect()
	rect.position = Vector2.ZERO
	draw_texture_rect(gradient_texture_2d, rect, false)

func clear() -> void:
	gradient_texture_2d = null
	from_point.point_position = Vector2(0, 0)
	to_point.point_position = Vector2(1, 0)

func _set_gradient_texture_2d(value : GradientTexture2D) -> void:
	if value == null:
		value = GradientTexture2D.new()
	
	if gradient_texture_2d != null:
		gradient_texture_2d = null
	
	gradient_texture_2d = value
	
	from_point.point_position = gradient_texture_2d.fill_from
	to_point.point_position = gradient_texture_2d.fill_to

func _set_editable(value : bool) -> void:
	editable = value
	visible = value

class Point extends  Control:
	var point_position : Vector2 : set = _set_point_position
	var parent : Control
	var is_hovered : bool = false
	var is_dragging : bool = false
	var is_to_point: bool = false
	var position_initial : Vector2
	var mouse_position_initial : Vector2
	
	func _init(_parent : Control, _is_to_point : bool) -> void:
		size = Vector2(10, 10)
		
		parent = _parent
		is_to_point = _is_to_point
		
		if is_to_point:
			rotation_degrees = 45
		
		mouse_entered.connect(_on_mouse_entered)
		mouse_exited.connect(_on_mouse_exited)
	
	func _draw() -> void:
		if is_hovered or is_dragging:
			draw_rect(Rect2(Vector2.ZERO, size), Color.AQUA, true)
		else:
			draw_rect(Rect2(Vector2.ZERO, size), Color.WHITE, true)
		
		draw_rect(Rect2(Vector2.ZERO, size), Color.BLACK, false, 0.5, true)
	
	func _gui_input(event: InputEvent) -> void:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			handle_mouse_button_event(event)
		
		if event is InputEventMouseMotion:
			handle_mouse_motion_event(event)
		
		queue_redraw()
	
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
			var new_position : Vector2 = event.global_position + position_initial - mouse_position_initial
			
			point_position = new_position / parent.size
	
	func _set_point_position(value : Vector2) -> void:
		point_position = value.clamp(Vector2.ZERO, Vector2(1, 1))
		var new_position : Vector2 = point_position * parent.size
		
		if is_to_point:
			parent.gradient_texture_2d.fill_to = point_position
			var half_size : float = sqrt(pow(size.x, 2) + pow(size.x, 2)) / 2
			position = new_position - Vector2(0, half_size)
		else:
			parent.gradient_texture_2d.fill_from = point_position
			var half_size : Vector2 = size / 2
			position = new_position - half_size
	
	func _on_mouse_entered() -> void:
		is_hovered = true
		queue_redraw()
	
	func _on_mouse_exited() -> void:
		is_hovered = false
		queue_redraw()
