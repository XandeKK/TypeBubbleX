extends Camera2D

var is_panning : bool = false
var initial_touch : Vector2
var initial_camera_position : Vector2

func _input(event: InputEvent) -> void:
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

func zoom_in() -> void:
	var new_zoom : Vector2 = zoom + Vector2(Preferences.general.camera.zoom_rate, Preferences.general.camera.zoom_rate)
	if new_zoom.x <= Preferences.general.camera.max_zoom and new_zoom.y <= Preferences.general.camera.max_zoom:
		zoom = new_zoom

func zoom_out() -> void:
	var new_zoom : Vector2 = zoom - Vector2(Preferences.general.camera.zoom_rate, Preferences.general.camera.zoom_rate)
	if new_zoom.x >= Preferences.general.camera.min_zoom and new_zoom.y >= Preferences.general.camera.min_zoom:
		zoom = new_zoom

func pan(event) -> void:
	var delta = (initial_touch - event.position) / zoom
	position = initial_camera_position + delta
