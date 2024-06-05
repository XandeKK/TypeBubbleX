extends Control

var parent : TextureRect

var point : int

var is_dragging : float = false
var drag_offset : Vector2
var is_within : float = false

var target_inital : Vector2
var mouse_inital : Vector2

var color : Color : set = _set_color

signal position_changed(point)

func _ready():
	parent = get_parent()
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _draw():
	draw_rect(Rect2(Vector2(-1, -1), size + Vector2(2, 2)), color.inverted())
	draw_rect(Rect2(Vector2.ZERO, size), color)

func _input(event : InputEvent):
	if is_within and event is InputEventMouseButton and \
		event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			
		parent.remove_point(self)
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if is_within and event.is_pressed():
			set_focus()
			if not is_dragging:
				is_dragging = true
				target_inital = position
				mouse_inital = event.position
		if is_dragging and not event.is_pressed():
			is_dragging = false
	
	if event is InputEventMouseMotion and is_dragging:
		drag_offset = target_inital - mouse_inital
		position.x = event.position.x + drag_offset.x
		
		var half_size = size.x / 2
		position.x = min(max(position.x, -half_size), parent.size.x - half_size)
		
		emit_signal('position_changed', self)

func set_focus() -> void:
	if parent.point_focused == self:
		return
	
	parent.point_focused = self

func _on_mouse_entered():
	is_within = true

func _on_mouse_exited():
	is_within = false

func _set_color(value : Color) -> void:
	color = value
