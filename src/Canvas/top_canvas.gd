extends SubViewportContainer

@onready var camera : Camera2D = $SubViewport/Camera2D
@onready var bottom_canvas : SubViewportContainer = $SubViewport/BottomCanvas
@onready var bottom_canvas_sub_viewport : SubViewport = $SubViewport/BottomCanvas/SubViewport
@onready var raw_image : TextureRect = $SubViewport/BottomCanvas/SubViewport/RawImage
@onready var cleaned_image : TextureRect = $SubViewport/BottomCanvas/SubViewport/CleanedImage
@onready var draw_observer : Control = $SubViewport/BottomCanvas/SubViewport/DrawObserver
@onready var objects : Node = $SubViewport/BottomCanvas/SubViewport/Objects

var focused_object : Control = null : get = get_object
var style : Preference.HQStyles : get = _get_style, set = _set_style

signal object_focus_changed(node : Control)
signal object_added(node : Control)
signal object_removed(node : Control)

func _ready() -> void:
	draw_observer.target = self

func load_raw_image(texture : ImageTexture) -> void:
	raw_image.texture = texture
	raw_image.size = texture.get_size()

func load_cleaned_image(texture : ImageTexture) -> void:
	cleaned_image.texture = texture
	bottom_canvas.size = texture.get_size()
	cleaned_image.size = texture.get_size()
	
	camera.position = Vector2(texture.get_size().x / 2, get_viewport().size.y - 50)

func add_object(packed_scene : PackedScene, start_position : Vector2, end_position : Vector2) -> void:
	if not packed_scene:
		return

	var obj = packed_scene.instantiate()
	objects.add_child(obj)
	obj.focused.connect(focus)
	var min_pos = Vector2(min(start_position.x, end_position.x), min(start_position.y, end_position.y))
	var max_pos = Vector2(max(start_position.x, end_position.x), max(start_position.y, end_position.y))
	obj.init(min_pos, max_pos - min_pos, style)
	
	emit_signal('object_added', obj)

func remove_object(node : Control):
	focus(null)
	node.queue_free()
	emit_signal('object_removed', node)

func focus(node : Control) -> void:
	if focused_object:
		focused_object.set_focus(false, false)
	if focused_object == node:
		return
	focused_object = node
	emit_signal('object_focus_changed', node)

func get_object() -> Control:
	return focused_object

func show_raw(status : bool) -> void:
	raw_image.visible = status
	draw_observer.can_draw = not status

func clear_texts() -> void:
	for child in objects.get_children():
		child.text.text = ''

func remove_texts() -> void:
	for child in objects.get_children():
		remove_object(child)

func _get_style() -> Preference.HQStyles:
	return style

func _set_style(value : Preference.HQStyles) -> void:
	style = value

func _get_bottom_canvas_sub_viewport() -> SubViewport:
	return bottom_canvas_sub_viewport

func to_dictionary() -> Dictionary:
	return {
		'texts': objects.get_children().map(func(text): return text.to_dictionary()),
		'raw_image': raw_image.texture.get_image(),
		'cleaned_image': cleaned_image.texture.get_image()
	}

func load(data : Dictionary) -> void:
	var _raw_image : Image = Image.new()
	var _cleaned_image : Image = Image.new()
	
	match data['extension']:
		'png':
			_raw_image.load_png_from_buffer(data['raw_image'])
			_cleaned_image.load_png_from_buffer(data['cleaned_image'])
		'jpg':
			_raw_image.load_jpg_from_buffer(data['raw_image'])
			_cleaned_image.load_jpg_from_buffer(data['cleaned_image'])
		'webp':
			_raw_image.load_webp_from_buffer(data['raw_image'])
			_cleaned_image.load_webp_from_buffer(data['cleaned_image'])
	
	load_raw_image(ImageTexture.create_from_image(_raw_image))
	load_cleaned_image(ImageTexture.create_from_image(_cleaned_image))
	
	var text_scene : PackedScene = load("res://src/SuperLabel/super_label.tscn")
	
	for text in data['texts']:
		add_object(text_scene, text['position'], text['position'] + text['size'])
		objects.get_child(-1).load(text)

func get_image() -> Image:
	var raw_visible : bool = raw_image.visible
	raw_image.hide()
	
	for object : Control in objects.get_children():
		object.can_draw = false
		object.queue_redraw()
	
	await RenderingServer.frame_post_draw

	var image : Image = bottom_canvas_sub_viewport.get_texture().get_image()
	
	for object in objects.get_children():
		object.can_draw = true
		object.queue_redraw()
	
	raw_image.visible = raw_visible
	
	return image
