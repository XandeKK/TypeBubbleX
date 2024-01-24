extends Control
class_name Perspective

var target : Control : set = _set_target

var can_draw : bool = true : set = _set_can_draw
var active : bool = false : get = _get_active, set = _set_active

var top_left : Point = Point.new()
var top_right : Point = Point.new()
var bottom_left : Point = Point.new()
var bottom_right : Point = Point.new()

var top_left_position_initial : Vector2
var top_right_position_initial : Vector2
var bottom_left_position_initial : Vector2
var bottom_right_position_initial : Vector2

func _ready():
	active = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	target.add_child(top_left)
	target.add_child(top_right)
	target.add_child(bottom_left)
	target.add_child(bottom_right)
	
	top_left.target = target
	top_right.target = target
	bottom_left.target = target
	bottom_right.target = target
	
	top_left.position_changed.connect(_on_top_left_position_changed)
	top_right.position_changed.connect(_on_top_right_position_changed)
	bottom_left.position_changed.connect(_on_bottom_left_position_changed)
	bottom_right.position_changed.connect(_on_bottom_right_position_changed)

func _draw():
	if not can_draw or not active:
		return
	
	if target.focus:
		var half_size : Vector2 = top_left.size / 2
		
		draw_line(top_left.position + half_size, top_right.position + half_size, Color.BLUE, 1)
		draw_line(top_left.position + half_size, bottom_left.position + half_size, Color.BLUE, 1)
		draw_line(bottom_left.position + half_size, bottom_right.position + half_size, Color.BLUE, 1)
		draw_line(top_right.position + half_size, bottom_right.position + half_size, Color.BLUE, 1)

func reset() -> void:
	var half_size : Vector2 = top_left.size / 2
	
	top_left.position = Vector2.ZERO - half_size
	top_right.position = Vector2(target.size.x, 0) - half_size
	bottom_left.position = Vector2(0, target.size.y) - half_size
	bottom_right.position = target.size - half_size
	
	top_left_position_initial = top_left.position
	top_right_position_initial = top_right.position
	bottom_left_position_initial = bottom_left.position
	bottom_right_position_initial = bottom_right.position
	
	_on_top_left_position_changed()
	_on_top_right_position_changed()
	_on_bottom_left_position_changed()
	_on_bottom_right_position_changed()

func _on_top_left_position_changed() -> void:
	var _position : Vector2 = top_left.position - top_left_position_initial
	target.sub_viewport_container.material.set_shader_parameter('top_left', _position)
	queue_redraw()

func _on_top_right_position_changed() -> void:
	var _position : Vector2 = top_right.position - top_right_position_initial
	target.sub_viewport_container.material.set_shader_parameter('top_right', _position)
	queue_redraw()

func _on_bottom_left_position_changed() -> void:
	var _position : Vector2 = bottom_left.position - bottom_left_position_initial
	target.sub_viewport_container.material.set_shader_parameter('bottom_left', _position)
	queue_redraw()

func _on_bottom_right_position_changed() -> void:
	var _position : Vector2 = bottom_right.position - bottom_right_position_initial
	target.sub_viewport_container.material.set_shader_parameter('bottom_right', _position)
	queue_redraw()

func _set_target(value : Control) -> void:
	target = value
	
	reset()

func _set_can_draw(value : bool) -> void:
	can_draw = value
	
	queue_redraw()
	top_left.queue_redraw()
	top_right.queue_redraw()
	bottom_left.queue_redraw()
	bottom_right.queue_redraw()

func _get_active() -> bool:
	return active

func _set_active(value : bool) -> void:
	active = value
	
	target.lock(value)
	
	queue_redraw()
	
	top_left.active = active
	top_right.active = active
	bottom_left.active = active
	bottom_right.active = active

func to_dictionary() -> Dictionary:
	return {
		'top_left': {
			'position': top_left.position,
			'position_initial': top_left_position_initial
		},
		'top_right': {
			'position': top_right.position,
			'position_initial': top_right_position_initial
		},
		'bottom_left': {
			'position': bottom_left.position,
			'position_initial': bottom_left_position_initial
		},
		'bottom_right': {
			'position': bottom_right.position,
			'position_initial': bottom_right_position_initial
		}
	}

func load(data : Dictionary) -> void:
	top_left.position = data['top_left']['position']
	top_right.position = data['top_right']['position']
	bottom_left.position = data['bottom_left']['position']
	bottom_right.position = data['bottom_right']['position']
	
	top_left_position_initial = data['top_left']['position_initial']
	top_right_position_initial = data['top_right']['position_initial']
	bottom_left_position_initial = data['bottom_left']['position_initial']
	bottom_right_position_initial = data['bottom_right']['position_initial']
	
	top_left.emit_signal('position_changed')
	top_right.emit_signal('position_changed')
	bottom_left.emit_signal('position_changed')
	bottom_right.emit_signal('position_changed')

func _exit_tree():
	top_left.queue_free()
	top_right.queue_free()
	bottom_left.queue_free()
	bottom_right.queue_free()
