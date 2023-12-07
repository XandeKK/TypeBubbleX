extends Camera2D

var min_zoom : float = 0.2
var max_zoom : float = 1.5
var zoom_rate : float = 0.1

var is_panning : bool = false
var initial_touch : Vector2
var initial_camera_position : Vector2

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.is_pressed():
			zoom_out()
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_pressed():
			zoom_in()
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				is_panning = true
				initial_touch = event.position
				initial_camera_position = position
			elif event.is_released():
				is_panning = false

	elif event is InputEventMouseMotion and is_panning:
		pan(event)

func zoom_in():
	var new_zoom = zoom + Vector2(zoom_rate, zoom_rate)
	if new_zoom.x <= max_zoom and new_zoom.y <= max_zoom:
		zoom = new_zoom

func zoom_out():
	var new_zoom = zoom - Vector2(zoom_rate, zoom_rate)
	if new_zoom.x >= min_zoom and new_zoom.y >= min_zoom:
		zoom = new_zoom

func pan(event):
	var delta = (initial_touch - event.position) / zoom
	position = initial_camera_position + delta
