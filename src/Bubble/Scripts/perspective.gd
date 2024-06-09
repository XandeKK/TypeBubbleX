extends Control
class_name Perspective

var bubble : Control : set = _set_bubble

var can_draw : bool = true : set = _set_can_draw
var active : bool = false : get = _get_active, set = _set_active

var points : Dictionary = {
	'top_left': {
		'position_initial': Vector2.ZERO,
		'position': Vector2.ZERO,
		'dragging': false
		},
	'top_right': {
		'position_initial': Vector2.ZERO,
		'position': Vector2.ZERO,
		'dragging': false
		},
	'bottom_left': {
		'position_initial': Vector2.ZERO,
		'position': Vector2.ZERO,
		'dragging': false
		},
	'bottom_right': {
		'position_initial': Vector2.ZERO,
		'position': Vector2.ZERO,
		'dragging': false
		},
}

var size_point : Vector2 = Vector2(15, 15)
var dragging : bool = false
var target_inital : Vector2
var mouse_inital : Vector2

func _ready():
	active = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _draw():
	if not can_draw or not active:
		return
	
	if bubble.focus:
		var half_size : Vector2 = size_point / 2
		
		draw_line(points.top_left.position + half_size, points.top_right.position + half_size, Color.BLUE, 1, true)
		draw_line(points.top_left.position + half_size, points.bottom_left.position + half_size, Color.BLUE, 1, true)
		draw_line(points.bottom_left.position + half_size, points.bottom_right.position + half_size, Color.BLUE, 1, true)
		draw_line(points.top_right.position + half_size, points.bottom_right.position + half_size, Color.BLUE, 1, true)
		
		for point in points.values():
			draw_circle(point.position + half_size, half_size.x, Color.RED)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		for point in points.values():
			if not dragging and event.pressed:
				var mouse_position : Vector2 = get_local_mouse_position()
				
				if (mouse_position - (point.position + size_point / 2)).length() < size_point.x / 2:
					target_inital = point.position
					mouse_inital = mouse_position
					dragging = true
					point.dragging = true
			
		if dragging and not event.pressed:
			dragging = false
			for point in points.values():
				point.dragging = false
	
	if event is InputEventMouseMotion and dragging:
		for point_key in points:
			var point : Dictionary = points[point_key]
			if point.dragging:
				var drag_offset = target_inital - mouse_inital
				point.position = get_local_mouse_position() + drag_offset
				var _position : Vector2 = point.position - point.position_initial
				bubble.sub_viewport_container.material.set_shader_parameter(point_key, _position)
				queue_redraw()

func reset() -> void:
	var half_size : Vector2 = size_point / 2
	
	points.top_left.position = Vector2.ZERO - half_size
	points.top_right.position = Vector2(bubble.size.x, 0) - half_size
	points.bottom_left.position = Vector2(0, bubble.size.y) - half_size
	points.bottom_right.position = bubble.size - half_size
	
	points.top_left.position_initial = points.top_left.position
	points.top_right.position_initial = points.top_right.position
	points.bottom_left.position_initial = points.bottom_left.position
	points.bottom_right.position_initial = points.bottom_right.position
	
	for point_key in points:
		var point : Dictionary = points[point_key]
		var _position : Vector2 = point.position - point.position_initial
		bubble.sub_viewport_container.material.set_shader_parameter(point_key, _position)
	
	queue_redraw()

func _set_bubble(value : Control) -> void:
	bubble = value
	
	reset()

func _set_can_draw(value : bool) -> void:
	can_draw = value
	
	queue_redraw()

func _get_active() -> bool:
	return active

func _set_active(value : bool) -> void:
	active = value
	set_process_input(active)
	
	queue_redraw()

func to_dictionary() -> Dictionary:
	return {
		'top_left': {
			'position': points.top_left.position,
			'position_initial': points.top_left.position_initial
		},
		'top_right': {
			'position': points.top_right.position,
			'position_initial': points.top_right.position_initial
		},
		'bottom_left': {
			'position': points.bottom_left.position,
			'position_initial': points.bottom_left.position_initial
		},
		'bottom_right': {
			'position': points.bottom_right.position,
			'position_initial': points.bottom_right.position_initial
		}
	}

func load(data : Dictionary) -> void:
	points.top_left.position = data['top_left']['position']
	points.top_right.position = data['top_right']['position']
	points.bottom_left.position = data['bottom_left']['position']
	points.bottom_right.position = data['bottom_right']['position']
	
	points.top_left.position_initial = data['top_left']['position_initial']
	points.top_right.position_initial = data['top_right']['position_initial']
	points.bottom_left.position_initial = data['bottom_left']['position_initial']
	points.bottom_right.position_initial = data['bottom_right']['position_initial']
