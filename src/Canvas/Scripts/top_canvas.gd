extends SubViewportContainer
class_name Canvas

@onready var camera : Camera2D = $SubViewport/Camera
@onready var bottom_canvas : SubViewportContainer = $SubViewport/BottomCanvas
@onready var bottom_canvas_sub_viewport : SubViewport = $SubViewport/BottomCanvas/SubViewport
@onready var raw_image : TextureRect = $SubViewport/BottomCanvas/SubViewport/RawImage
@onready var cleaned_image : TextureRect = $SubViewport/BottomCanvas/SubViewport/CleanedImage
@onready var draw_observer : Control = $SubViewport/BottomCanvas/SubViewport/DrawObserver
@onready var bubbles : Node = $SubViewport/BottomCanvas/SubViewport/Bubbles

var bubble_scene : PackedScene = load("res://src/Bubble/bubble.tscn")
var focused_bubble : Bubble = null : get = get_focused_bubble
var type : Preference.HQTypes : get = _get_type, set = _set_type

signal bubble_focus_changed(node : Bubble)
signal bubble_added(node : Bubble)
signal bubble_removed(node : Bubble)

func _ready() -> void:
	Global.canvas = self
	draw_observer.top_canvas = self
	bottom_canvas.size = Vector2(512,512)

func load_raw_image(texture : ImageTexture) -> void:
	raw_image.texture = texture
	raw_image.size = texture.get_size()

func load_cleaned_image(texture : ImageTexture) -> void:
	cleaned_image.texture = texture
	bottom_canvas.size = texture.get_size()
	cleaned_image.size = texture.get_size()
	
	camera.position = Vector2(texture.get_size().x / 2, get_viewport().size.y - 50)

func add_bubble(start_position : Vector2, end_position : Vector2) -> void:
	var min_pos = Vector2(min(start_position.x, end_position.x), min(start_position.y, end_position.y))
	var max_pos = Vector2(max(start_position.x, end_position.x), max(start_position.y, end_position.y))
	
	if max_pos - min_pos < Vector2(10,10):
		return
	
	var obj = bubble_scene.instantiate()
	
	bubbles.add_child(obj)
	
	obj.focused.connect(focus)
	obj.init(min_pos, max_pos - min_pos, type)
	obj.canvas = self
	
	emit_signal('bubble_added', obj)

func remove_bubble(node : Bubble):
	focus(null)
	node.queue_free()
	emit_signal('bubble_removed', node)

func focus(node : Bubble) -> void:
	if focused_bubble:
		focused_bubble.set_focus(false, false)
	if focused_bubble == node:
		return
	focused_bubble = node
	emit_signal('bubble_focus_changed', node)

func get_focused_bubble() -> Bubble:
	return focused_bubble

func show_raw(status : bool) -> void:
	raw_image.visible = status
	draw_observer.can_draw = not status

func remove_bubbles() -> void:
	for bubble in bubbles.get_children():
		remove_bubble(bubble)

func _get_type() -> Preference.HQTypes:
	return type

func _set_type(value : Preference.HQTypes) -> void:
	type = value

func _get_bottom_canvas_sub_viewport() -> SubViewport:
	return bottom_canvas_sub_viewport

func to_dictionary() -> Dictionary:
	return {
		'texts': bubbles.get_children().map(func(text): return text.to_dictionary())
	}

func load(data : Dictionary) -> void:
	for text in data['texts']:
		add_bubble(text['position'], text['position'] + text['size'])
		bubbles.get_child(-1).load(text)

func add_boxes(boxes : Array) -> void:
	for box in boxes:
		var width = abs((box['x2'] - box['x1']))
		var height = abs((box['y2'] - box['y1']))
		add_bubble(Vector2(box['x1'], box['y1']), Vector2(box['x1'], box['y1']) + Vector2(width, height))

func get_image() -> Image:
	var raw_visible : bool = raw_image.visible
	raw_image.hide()
	
	for bubble : Bubble in bubbles.get_children():
		bubble.can_draw = false
	
	await RenderingServer.frame_post_draw

	var image : Image = bottom_canvas_sub_viewport.get_texture().get_image()
	
	for bubble in bubbles.get_children():
		bubble.can_draw = true
	
	raw_image.visible = raw_visible
	
	return image

func extract_data_for_ai() -> Array[Dictionary]:
	var data : Array[Dictionary] = []
	
	for bubble : Bubble in bubbles.get_children():
		if bubble.text.text_styles.list.is_empty():
			data.append(bubble.extract_data_for_ai())

	return data

func clear() -> void:
	for bubble in bubbles.get_children():
		bubble.queue_free()
