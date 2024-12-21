class_name TextPath2D
extends Path2D

var bubble : Bubble

var current_status : STATUS = STATUS.NONE
var current_point_index : int = -1
var current_point_in_index : int = -1
var current_point_out_index : int = -1
var radius : int = 5
var mouse_position_initial : Vector2
var path2d_position_initial : Vector2
var is_dragging : bool = false
var dragged_point_index : int = -1
var can_draw : bool = true
var visible_status : bool = true : set = _set_visible_status

enum STATUS {
	NONE,
	ADD,
	REMOVE,
	EDIT,
	MANIPULATE
}

func _init(_bubble : Bubble) -> void:
	curve = Curve2D.new()
	bubble = _bubble

func _draw():
	if not can_draw:
		return

	if curve.point_count >= 2:
		draw_polyline(curve.get_baked_points(), Color.AQUA, 1, true)
	
	if current_status == STATUS.EDIT:
		var mouse_position: Vector2 = get_local_mouse_position()
		var closest_point_position : Vector2 = curve.get_closest_point(mouse_position)
		var closest_distance: float = (mouse_position - closest_point_position).length()
	
		if closest_distance < radius:
			draw_circle(closest_point_position, radius, Color.FIREBRICK)
		
	for i in range(curve.point_count):
		draw_point(i)
	bubble.text._prepare_glyphs_to_render()

func _input(event: InputEvent) -> void:
	match current_status:
		STATUS.NONE:
			return
		STATUS.ADD:
			if is_dragging:
				move_point(event)
			else:
				add_point(event)
		STATUS.REMOVE:
			remove_point(event)
		STATUS.EDIT:
			edit_point(event)
		STATUS.MANIPULATE:
			manipulate_point(event)

func draw_point(index : int) -> void:
	var point_position : Vector2 = curve.get_point_position(index)
	var point_in : Vector2 = curve.get_point_in(index)
	var point_out : Vector2 = curve.get_point_out(index)
	
	draw_line(point_position, point_out + point_position, Color.REBECCA_PURPLE, 1, true)
	draw_line(point_position, point_in + point_position, Color.REBECCA_PURPLE, 1, true)
	draw_circle(point_position, 5, Color.RED)
	draw_circle(point_in + point_position, 5, Color.RED)
	draw_circle(point_out + point_position, 5, Color.RED)

func move_point(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if dragged_point_index != -1:
			curve.set_point_position(dragged_point_index, get_local_mouse_position())
			queue_redraw()
	else:
		is_dragging = false
		dragged_point_index = -1

func add_point(event : InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		curve.add_point(get_local_mouse_position())
		queue_redraw()
		
		dragged_point_index = curve.point_count - 1
		is_dragging = true

func remove_point(event : InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and curve.point_count > 2:
			for idx in range(curve.point_count):
				var point_position : Vector2 = curve.get_point_position(idx)
				if (get_local_mouse_position() - point_position).length() < radius:
					curve.remove_point(idx)
					queue_redraw()

func edit_point(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		handle_mouse_button_edit(event)
		if not is_dragging:
			insert_point(event)
			handle_mouse_button_edit(event)
		
	if event is InputEventMouseMotion and is_dragging:
		update_point_position()
	queue_redraw()

func insert_point(event : InputEvent) -> void:
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_position : Vector2 = get_local_mouse_position()
		var closest_point_position : Vector2 = curve.get_closest_point(mouse_position)
		var closest_distance: float = (mouse_position - closest_point_position).length()
	
		if closest_distance < radius:
			var index : int = get_curve_point_index_from_offset(curve.get_closest_offset(mouse_position))
			curve.add_point(closest_point_position, Vector2.ZERO, Vector2.ZERO, index)

func handle_mouse_button_edit(event : InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_LEFT:
		if not is_dragging and event.pressed:
			for idx in range(curve.point_count):
				if check_point_interaction(idx):
					is_dragging = true
					break
		elif is_dragging and not event.pressed:
			reset_drag_state()

func check_point_interaction(idx: int) -> bool:
	var point_position : Vector2 = curve.get_point_position(idx)
	var point_in_position : Vector2 = curve.get_point_in(idx)
	var point_out_position : Vector2 = curve.get_point_out(idx)
	var mouse_position : Vector2 = get_local_mouse_position()
	
	if (mouse_position - point_position).length() < radius:
		current_point_index = idx
		return true
	elif (mouse_position - (point_position + point_in_position)).length() < radius:
		current_point_in_index = idx
		return true
	elif (mouse_position - (point_position + point_out_position)).length() < radius:
		current_point_out_index = idx
		return true
	
	return false

func reset_drag_state() -> void:
	is_dragging = false
	current_point_index = -1
	current_point_in_index = -1
	current_point_out_index = -1

func update_point_position() -> void:
	var mouse_position : Vector2 = get_local_mouse_position()
	
	if current_point_index != -1:
		curve.set_point_position(current_point_index, mouse_position)
	elif current_point_in_index != -1:
		update_point_in(current_point_in_index, mouse_position)
	elif current_point_out_index != -1:
		update_point_out(current_point_out_index, mouse_position)

func update_point_in(point_index : int, mouse_position) -> void:
	var point_position = curve.get_point_position(point_index)
	
	curve.set_point_in(point_index, mouse_position - point_position)
	curve.set_point_out(point_index, -(mouse_position - point_position))
	
func update_point_out(point_index : int, mouse_position : Vector2) -> void:
	var point_position = curve.get_point_position(point_index)
	
	curve.set_point_out(point_index, mouse_position - point_position)
	curve.set_point_in(point_index, -(mouse_position - point_position))

func get_curve_point_index_from_offset(offset : float) -> int:
	var curve_point_length : int = curve.get_point_count()
	
	if curve_point_length < 2:
		return curve_point_length
	
	for idx in range(1, curve.get_point_count()):
		var current_point_offset = curve.get_closest_offset(curve.get_point_position(idx))
		
		if current_point_offset > offset:
			return idx

	return curve_point_length

func manipulate_point(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		handle_mouse_button_manipulate(event)
		
	if event is InputEventMouseMotion and is_dragging:
		update_point_position()
		queue_redraw()

func handle_mouse_button_manipulate(event : InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_LEFT:
		if not is_dragging and event.pressed:
			for idx in range(curve.point_count):
				if check_point_interaction(idx):
					is_dragging = true
					var point_in_position : Vector2 = curve.get_point_in(idx)
					var point_out_position : Vector2 = curve.get_point_out(idx)
	
					if current_point_index != -1 and current_point_in_index == -1 and current_point_out_index == -1 and point_in_position == Vector2.ZERO and point_out_position == Vector2.ZERO:
						current_point_out_index = current_point_index
					
					current_point_index = -1
					break
		elif is_dragging and not event.pressed:
			reset_drag_state()

func _set_visible_status(value : bool) -> void:
	visible_status = value
	visible = visible_status
	set_process_input(visible_status)

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
		'points': get_points()
	}

func load(data : Dictionary) -> void:
	curve.clear_points()
	
	for point in data['points']:
		curve.add_point(point.position, point.in, point.out)
	
	queue_redraw()
