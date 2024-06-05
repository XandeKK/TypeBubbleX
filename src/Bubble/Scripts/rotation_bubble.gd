extends Control
class_name RotationBubble

var bubble : Control = null : set = _set_bubble

var is_dragging : float = false
var is_within : float = false

func _set_bubble(value : Control) -> void:
	bubble = value
	readjust_size()
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func readjust_size():
	size = Vector2(25, 25)
	position = Vector2(bubble.size.x / 2 - size.x / 2, -50)

func _input(event):
	if not bubble or not bubble.focus:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if is_within:
			if not is_dragging and event.pressed:
				is_dragging = true
		if is_dragging and not event.pressed:
			is_dragging = false

	if event is InputEventMouseMotion and is_dragging:
		bubble.apply_rotation(convert_to_degrees())
	
	set_mouse_cursor()

func convert_to_degrees() -> int:
	var _rotation_rad : float = (bubble.pivot_offset + bubble.position).angle_to_point(get_global_mouse_position()) + deg_to_rad(90)
	var _rotation_deg = int(rad_to_deg(_rotation_rad))
	if _rotation_deg < 0:
		_rotation_deg = 360 + _rotation_deg
	return _rotation_deg

func set_mouse_cursor():
	if is_dragging:
		mouse_default_cursor_shape = Control.CURSOR_MOVE
	elif is_within:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _on_mouse_entered():
	is_within = true

func _on_mouse_exited():
	is_within = false
