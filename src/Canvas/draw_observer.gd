extends Control

var target : SubViewportContainer : set = _set_target

const text_scene : PackedScene = preload("res://src/SuperLabel/super_label.tscn")

var is_within : bool = false
var is_drawable : bool = false
var is_drawing : bool = false
var drawing_start_position : Vector2

func _draw():
	if is_drawing:
		var rect = Rect2(drawing_start_position, get_local_mouse_position() - drawing_start_position)
		draw_rect(rect, Color.AQUA, false, 3)

func _input(event):
	if event is InputEventKey and event.keycode == KEY_CTRL:
		is_drawable = event.is_pressed()
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and is_within:
		target.focus(null)
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if not is_drawing and is_drawable:
				is_drawing = true
				drawing_start_position = get_local_mouse_position()
		if is_drawing and not event.is_pressed():
			is_drawing = false
			add_text(drawing_start_position, get_local_mouse_position())
			queue_redraw()
	
	if event is InputEventMouseMotion and is_drawing:
		queue_redraw()

func add_text(drawing_start_position : Vector2, mouse_position : Vector2):
	target.add_object(text_scene, drawing_start_position , mouse_position, {'text': ''})

func _on_mouse_entered():
	is_within = true

func _on_mouse_exited():
	is_within = false

func _set_target(value : SubViewportContainer) -> void:
	target = value
