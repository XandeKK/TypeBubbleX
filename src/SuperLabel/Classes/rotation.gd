extends Control
class_name Rotation

var target : Control = null : set = _set_target

var is_dragging : float = false
var is_within : float = false

func _set_target(value : Control) -> void:
	target = value
	readjust_size()
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func readjust_size():
	size = Vector2(25, 25)
	position = Vector2(target.size.x / 2 - size.x / 2, -50)

func _input(event):
	if not target or not target.focus:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if is_within:
			if not is_dragging and event.pressed:
				is_dragging = true
		if is_dragging and not event.pressed:
			is_dragging = false

	if event is InputEventMouseMotion and is_dragging:
		target.set_rotation_text((target.pivot_offset + target.position).angle_to_point(get_global_mouse_position()) + deg_to_rad(90))

func _on_mouse_entered():
	is_within = true

func _on_mouse_exited():
	is_within = false
