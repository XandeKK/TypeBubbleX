class_name RotationBubble
extends Control

var bubble : Bubble = null
var is_dragging : float = false

func _init(_bubble : Bubble) -> void:
	bubble = _bubble
	_bubble.resized.connect(_on_resized)
	bubble.add_child(self)

func _draw() -> void:
	if bubble.is_focused:
		draw_rect(Rect2(Vector2.ZERO, size), Color.RED, true, -1.0, true)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not is_dragging and event.pressed:
			is_dragging = true
		if is_dragging and not event.pressed:
			is_dragging = false

	if event is InputEventMouseMotion and is_dragging:
		bubble.rotation_degrees = convert_to_degrees()
		bubble.rotation_changed.emit(bubble.rotation_degrees)

	set_mouse_cursor()

func _on_resized() -> void:
	size = Vector2(25, 25)
	position = Vector2(bubble.size.x / 2 - size.x / 2, -50)

func convert_to_degrees() -> int:
	var _rotation_rad : float = (bubble.pivot_offset + bubble.position).angle_to_point(get_global_mouse_position()) + deg_to_rad(90)
	var _rotation_deg = int(rad_to_deg(_rotation_rad))
	if _rotation_deg < 0:
		_rotation_deg = 360 + _rotation_deg
	return _rotation_deg

func set_mouse_cursor() -> void:
	if is_dragging:
		mouse_default_cursor_shape = Control.CURSOR_MOVE
	else:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
