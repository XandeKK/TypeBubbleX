extends Control

enum MODE {
	IDLE,
	ADD,
	EDIT
}

@export var mask : Polygon2D

var target : Control : set = _set_target

var is_dragging : bool = false
var active : bool = true : set = _set_active
var can_draw : bool = true : set = _set_can_draw
var lifted_point_idx : int = -1
var mode : MODE = MODE.EDIT : set = _set_mode

func _draw():
	if not can_draw or not target.focus or not active:
		return

	if mode == MODE.ADD and mask.polygon.size() > 0:
		draw_line(mask.polygon[-1], get_local_mouse_position(), Color.PURPLE)
		draw_line(mask.polygon[0], get_local_mouse_position(), Color.PURPLE)
	if mask.polygon.size() > 1:
		draw_polyline(mask.polygon, Color.BLUE)
		draw_line(mask.polygon[0], mask.polygon[-1], Color.BLUE)
	for point in mask.polygon:
		draw_rect(mkhandle(point), Color.GREEN)

func mkhandle(point):
	var _size = Vector2(8, 8)
	return Rect2(point - _size / 2, _size)

func _input(event):
	if not target.focus or not active:
		return

	if event is InputEventMouseButton:
		set_point(event)
		match mode:
			MODE.ADD:
				if event.button_index == MOUSE_BUTTON_LEFT:
					add_point(event)
				if event.button_index == MOUSE_BUTTON_RIGHT:
					delete_point()
			MODE.EDIT:
				if event.button_index == MOUSE_BUTTON_LEFT:
					if not is_dragging:
						is_dragging = true
				if event.button_index == MOUSE_BUTTON_RIGHT:
					delete_point()

	if event is InputEventMouseMotion and is_dragging:
		if lifted_point_idx != -1:
			event = make_input_local(event)
			mask.polygon[lifted_point_idx] = event.position
			queue_redraw()
	
	if mode == MODE.ADD:
		queue_redraw()

func add_point(event : InputEventMouseButton) -> void:
	if not event.pressed:
		return

	event = make_input_local(event)
	var polygon = mask.polygon
	polygon.append(event.position)
	mask.polygon = polygon
	queue_redraw()

func set_point(event : InputEventMouseButton) -> void:
	if not event.pressed:
		lifted_point_idx = -1
	elif lifted_point_idx == -1:
		event = make_input_local(event)
		for i in mask.polygon.size():
			if mkhandle(mask.polygon[i]).has_point(event.position):
				lifted_point_idx = i

func delete_point() -> void:
	if mask.polygon.size() < 1 or lifted_point_idx == -1:
		return
	
	var polygon = mask.polygon
	
	polygon.remove_at(lifted_point_idx)
	mask.polygon = polygon
	
	lifted_point_idx = -1
	queue_redraw()

func _set_target(value : Control) -> void:
	target = value

func _set_can_draw(value : bool) -> void:
	can_draw = value
	
	queue_redraw()

func _set_mode(value : MODE) -> void:
	mode = value
	
	target.lock(mode != MODE.IDLE)
	set_process_input(mode != MODE.IDLE)
	
	queue_redraw()

func _set_active(value : bool) -> void:
	active = value
	
	if not active:
		mask.polygon.clear()
	
	queue_redraw()
