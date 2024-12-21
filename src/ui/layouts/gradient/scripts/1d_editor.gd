class_name G1DEditor
extends Control

@export var color_picker : ColorPickerButton

var texture : GradientTexture1D = GradientTexture1D.new()
var gradient : Gradient : set = _set_gradient
var points : Array[Point]
var current_point : Point : set = _set_current_point

func _ready() -> void:
	current_point = null

func _exit_tree() -> void:
	clear()

func _draw() -> void:
	draw_texture_rect(texture, get_rect(), false)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var offset : float = event.position.x / size.x
		var color : Color = gradient.sample(offset)
		
		gradient.add_point(offset, color)
		
		var point : Point = Point.new(gradient.get_point_count() - 1, color, offset, self)
		add_child(point)
		points.append(point)
		
		current_point = point
		
		sort_points()

func clear() -> void:
	for point : Point in points:
		point.queue_free()
	
	points.clear()

func _set_gradient(value : Gradient) -> void:
	current_point = null
	clear()
	
	gradient = value
	texture.gradient = gradient
	
	if value == null:
		return
	
	for i in range(gradient.get_point_count()):
		var point : Point = Point.new(i, gradient.get_color(i), gradient.get_offset(i), self)
		add_child(point)
		points.append(point)

func set_offset_point(point : int, offset : float) -> void:
	gradient.set_offset(point, offset)
	sort_points()

func sort_points() -> void:
	points.sort_custom(func(a, b): return a.position.x < b.position.x)
	
	var index = 0
	for point : Point in points:
		move_child(point, index)
		point.point = index
		index += 1

func remove_point(point : Point) -> void:
	if points.size() == 1:
		push_error("There must be at least one gradient point")
		return

	points.remove_at(point.point)
	gradient.remove_point(point.point)
	point.queue_free()
	
	current_point = null
	color_picker.disabled = true
	color_picker.color = Color.BLACK
	
	sort_points()

func _set_current_point(value : Point) -> void:
	current_point = value
	
	if current_point == null:
		color_picker.disabled = true
		return
	
	color_picker.color = current_point.color
	color_picker.disabled = false

func _on_color_picker_button_color_changed(color : Color) -> void:
	if current_point == null:
		return
	
	current_point.color = color
	gradient.set_color(current_point.point, color)
	current_point.queue_redraw()

class Point extends Control:
	var point : int
	var color : Color
	var offset : float
	var parent : Control
	var is_hovered : bool = false
	var is_dragging : bool = false
	var position_initial : Vector2
	var mouse_position_initial : Vector2
	
	func _init(_point : int, _color : Color, _offset : float, _parent : Control) -> void:
		point = _point
		color = _color
		offset = _offset
		parent = _parent
		
		mouse_entered.connect(_on_mouse_entered)
		mouse_exited.connect(_on_mouse_exited)
		parent.resized.connect(_on_parent_resized)
		
		_on_parent_resized()
	
	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO, size), color, true)
		
		if is_dragging:
			draw_rect(Rect2(Vector2(1, 1), size - Vector2(2, 2)), color.inverted(), false, 1)
		elif is_hovered:
			draw_rect(Rect2(Vector2(1, 1), size - Vector2(2, 2)), color.inverted(), false, 1)
			draw_rect(Rect2(Vector2.ZERO, size), color.inverted(), false, 1)
		else:
			draw_rect(Rect2(Vector2.ZERO, size), color.inverted(), false, 1)
	
	func _gui_input(event: InputEvent) -> void:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				handle_mouse_button_event(event)
				parent.current_point = self
			elif event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
				parent.remove_point(self)
		
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
			var new_position_x : float = event.global_position.x + position_initial.x - mouse_position_initial.x
			var half_size_x : float = size.x / 2
			
			position.x = clamp(new_position_x, -half_size_x, parent.size.x - half_size_x)
			offset = clamp((new_position_x + half_size_x) / parent.size.x, 0, 1)
			
			parent.set_offset_point(point, offset)
	
	func _on_parent_resized() -> void:
		size = Vector2(8, parent.size.y * 0.7)
		position = Vector2(parent.size.x * offset - size.x / 2, parent.size.y * 0.3)
		
		queue_redraw()
	
	func _on_mouse_entered() -> void:
		is_hovered = true
		queue_redraw()
	
	func _on_mouse_exited() -> void:
		is_hovered = false
		queue_redraw()
