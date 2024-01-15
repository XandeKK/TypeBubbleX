extends Control
class_name Point

var target : Control = null : set = _set_target

var can_draw : bool = true : set = _set_can_draw
var active : bool = false : set = _set_active

var is_dragging : float = false
var drag_offset : Vector2
var is_within : float = false

var target_inital : Vector2
var mouse_inital : Vector2

signal position_changed

func _ready():
	size = Vector2(15, 15)

func _draw():
	if active and can_draw and target.focus:
		draw_rect(Rect2(Vector2.ZERO, size), Preference.colors.text_edge.active)

func _input(event : InputEvent):
	if not target or not target.focus:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if is_within and event.is_pressed():
			if not is_dragging:
				is_dragging = true
				target_inital = global_position
				mouse_inital = event.position
		if is_dragging and not event.is_pressed():
			is_dragging = false
	
	if event is InputEventMouseMotion and is_dragging:
		drag_offset = target_inital - mouse_inital
		global_position = event.position + drag_offset
		emit_signal('position_changed')
	
	set_mouse_cursor()

func set_mouse_cursor():
	if is_dragging:
		mouse_default_cursor_shape = Control.CURSOR_MOVE
	elif is_within:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _on_mouse_entered():
	is_within = true

func _on_mouse_exited():
	is_within = false

func _set_target(value : Control) -> void:
	target = value
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _set_can_draw(value : bool) -> void:
	can_draw = value
	
	queue_redraw()

func _set_active(value : bool) -> void:
	active = value
	visible = active
	queue_redraw()
