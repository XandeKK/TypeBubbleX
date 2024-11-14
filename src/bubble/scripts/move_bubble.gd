class_name MoveBubble
extends Node

var bubble : Bubble = null

var is_dragging : bool = false
var is_draggable : bool = false

var drag_offset : Vector2
var bubble_position_initial : Vector2
var mouse_position_initial : Vector2

func _init(_bubble : Bubble) -> void:
	bubble = _bubble

func gui_input(event : InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		handle_mouse_button_event(event)
	
	if event is InputEventMouseMotion and is_dragging and is_draggable:
		handle_mouse_motion_event()

	set_mouse_cursor()

func handle_mouse_button_event(event : InputEventMouseButton) -> void:
	if event.shift_pressed:
		is_draggable = event.is_pressed()

	if event.is_pressed():
		set_focus()
		if not is_dragging and is_draggable:
			start_dragging()

	if is_dragging and not event.is_pressed():
		stop_dragging()

func start_dragging() -> void:
	is_dragging = true
	bubble_position_initial = bubble.position
	mouse_position_initial = bubble.get_global_mouse_position()

func stop_dragging() -> void:
	is_dragging = false

func handle_mouse_motion_event() -> void:
	drag_offset = bubble_position_initial - mouse_position_initial
	bubble.position = bubble.get_global_mouse_position() + drag_offset

func set_mouse_cursor() -> void:
	if is_dragging:
		bubble.mouse_default_cursor_shape = Control.CURSOR_MOVE
	else:
		bubble.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func set_focus() -> void:
	if not bubble.is_focused:
		bubble.set_focus(true)
