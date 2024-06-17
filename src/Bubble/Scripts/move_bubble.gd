extends Node
class_name MoveBubble

var bubble : Control = null : set = _set_bubble

var is_dragging : float = false
var is_draggable : float = false
var drag_offset : Vector2
var is_within : float = false

var bubble_position_inital : Vector2
var mouse_position_inital : Vector2

func input(event : InputEvent):
	if not bubble:
		return

	if event is InputEventKey and event.keycode == KEY_SHIFT:
		is_draggable = event.is_pressed()

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if is_within and event.is_pressed():
			set_focus()
			if not is_dragging and is_draggable:
				is_dragging = true
				bubble_position_inital = bubble.position
				mouse_position_inital = event.position
		if is_dragging and not event.is_pressed():
			is_dragging = false
	
	if event is InputEventMouseMotion and is_dragging and is_draggable:
		drag_offset = bubble_position_inital - mouse_position_inital
		bubble.position = event.position + drag_offset
	
	set_mouse_cursor()

func set_mouse_cursor():
	if is_dragging:
		bubble.mouse_default_cursor_shape = Control.CURSOR_MOVE
	elif is_within:
		bubble.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func set_focus():
	if not bubble.focus:
		bubble.set_focus()

func _on_mouse_entered():
	is_within = true

func _on_mouse_exited():
	is_within = false

func _set_bubble(value : Control) -> void:
	bubble = value
	bubble.mouse_entered.connect(_on_mouse_entered)
	bubble.mouse_exited.connect(_on_mouse_exited)
