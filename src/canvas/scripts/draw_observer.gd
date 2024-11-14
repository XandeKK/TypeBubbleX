class_name DrawObserver
extends Control

var top_canvas : TopCanvas

var is_drawing : bool = false
var drawing_start_position : Vector2

func _draw() -> void:
	if is_drawing:
		var rect = Rect2(drawing_start_position, get_local_mouse_position() - drawing_start_position)
		draw_rect(rect, Color.AQUA, false, 3)

func _gui_input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if not is_drawing and event.ctrl_pressed:
				is_drawing = true
				drawing_start_position = get_local_mouse_position()
		if is_drawing and not event.is_pressed():
			is_drawing = false
			add_bubble(drawing_start_position, get_local_mouse_position())
			queue_redraw()
	
	if event is InputEventMouseMotion and is_drawing:
		queue_redraw()

func add_bubble(start_position : Vector2, mouse_position : Vector2):
	top_canvas.add_bubble(start_position , mouse_position)
