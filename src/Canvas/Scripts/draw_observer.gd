extends Control

var top_canvas : SubViewportContainer : set = _set_top_canvas

var can_draw : bool = true : set = _set_can_draw
var is_within : bool = false
var is_drawable : bool = false
var is_drawing : bool = false
var drawing_start_position : Vector2

func _draw():
	if is_drawing:
		var rect = Rect2(drawing_start_position, get_local_mouse_position() - drawing_start_position)
		draw_rect(rect, Color.AQUA, false, 3)

func _input(event):
	if not can_draw:
		return

	if event is InputEventKey and event.keycode == KEY_CTRL:
		is_drawable = event.is_pressed()
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and is_within:
		top_canvas.focus(null)
	
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

func add_text(start_position : Vector2, mouse_position : Vector2):
	top_canvas.add_bubble(start_position , mouse_position)

func _on_mouse_entered():
	is_within = true

func _on_mouse_exited():
	is_within = false

func _set_top_canvas(value : SubViewportContainer) -> void:
	top_canvas = value

func _set_can_draw(value : bool) -> void:
	can_draw = value
