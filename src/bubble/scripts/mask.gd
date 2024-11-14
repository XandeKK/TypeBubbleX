class_name Mask
extends Control

var sub_viewport : SubViewport
var brush_cursor : Control : set = _set_brush_cursor

var redo_stack : Array
var undo_stack : Array

var image_texture : ImageTexture : set = _set_image_texture
var width : int = 10 : set = _set_width
var last_mouse_position : Vector2 = Vector2(-1, -1)
var is_drawing : bool = false
var current_position : Vector2 = Vector2.ZERO
var is_texture_ready : bool = false
var color : Color = Color.WHITE

func _ready() -> void:
	sub_viewport = get_parent()

func _draw() -> void:
	if is_texture_ready:
		draw_texture(image_texture, Vector2.ZERO)
		is_texture_ready = false
	
	if not is_drawing or current_position == last_mouse_position:
		return

	if last_mouse_position != Vector2(-1, -1):
		var dist_sqr : float = last_mouse_position.distance_squared_to(current_position)
		
		if distance_too_big(dist_sqr):
			put_brush_dot(current_position)
			draw_interpolated(dist_sqr)
		else:
			put_brush_dot(current_position)
		last_mouse_position = current_position
	else:
		last_mouse_position = current_position
		put_brush_dot(current_position)

func gui_input(event: InputEvent) -> void:
	if event as InputEventMouseMotion:
		current_position = event.position
		queue_redraw()
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_drawing =  true
			
			undo_stack.append(sub_viewport.get_texture().get_image())
			redo_stack.clear()
			queue_redraw()
		else:
			is_drawing =  false
			last_mouse_position = Vector2(-1, -1)

func distance_too_big(dist2 : float) -> bool:
	return dist2 > max_dist_btwn_dots() * max_dist_btwn_dots()

func draw_interpolated(dist_sqr : float) -> void:
	var dir_vector : Vector2 = last_mouse_position.direction_to(current_position)
	dir_vector = dir_vector * max_dist_btwn_dots()
	
	var interpVector : Vector2 = Vector2(dir_vector)
	
	while interpVector.length_squared() < dist_sqr:
		put_brush_dot(last_mouse_position + interpVector)
		interpVector += dir_vector

func max_dist_btwn_dots() -> float:
	return width / 3.0

func put_brush_dot(_pos) -> void:
	draw_circle(_pos, width, color)

func redo() -> void:
	if redo_stack.is_empty():
		push_error("Can't use redo")
		return
	
	var image : Image = redo_stack.pop_back()
	
	undo_stack.append(sub_viewport.get_texture().get_image())
	image_texture = ImageTexture.create_from_image(image)

func undo() -> void:
	if undo_stack.is_empty():
		push_error("Can't use undo")
		return
	
	var image : Image = undo_stack.pop_back()
	
	redo_stack.append(sub_viewport.get_texture().get_image())
	image_texture = ImageTexture.create_from_image(image)

func _set_image_texture(value : ImageTexture) -> void:
	image_texture = value
	is_texture_ready = true
	sub_viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ONCE
	queue_redraw()

func _set_width(value : int) -> void:
	width = value
	brush_cursor.width = width

func _set_brush_cursor(value : Control) -> void:
	brush_cursor = value
	brush_cursor.width = width

func to_dictionary() -> Dictionary:
	return {
		'image_buffer': sub_viewport.get_texture().get_image().save_png_to_buffer()
	}

func load(data : Dictionary) -> void:
	var image : Image = Image.new()
	image.load_png_from_buffer(data['image_buffer'])
	get_tree().create_timer(0.001).timeout.connect(func():
		image_texture = ImageTexture.create_from_image(image)
	)
	
