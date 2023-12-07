extends Node
class_name Move

var target : Control = null : set = _set_target

var is_dragging : float = false
var is_draggable : float = false
var drag_offset : Vector2
var is_within : float = false

var target_inital : Vector2
var mouse_inital : Vector2

func input(event : InputEvent):
	if not target:
		return

	if event is InputEventKey and event.keycode == KEY_SHIFT:
		is_draggable = event.is_pressed()

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if is_within and event.is_pressed():
			set_focus()
			if not is_dragging and is_draggable:
				is_dragging = true
				target_inital = target.position
				mouse_inital = event.position
		if is_dragging and not event.is_pressed():
			is_dragging = false

	if event is InputEventMouseMotion and is_dragging and is_draggable:
		drag_offset = target_inital - mouse_inital
		target.position = event.position + drag_offset

func set_focus():
	if not target.focus:
		target.set_focus()

func _on_mouse_entered():
	is_within = true

func _on_mouse_exited():
	is_within = false

func _set_target(value : Control) -> void:
	target = value
	target.mouse_entered.connect(_on_mouse_entered)
	target.mouse_exited.connect(_on_mouse_exited)
