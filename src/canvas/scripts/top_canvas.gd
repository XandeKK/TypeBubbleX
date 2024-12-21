class_name TopCanvas
extends SubViewportContainer

@onready var camera2d : Camera2D = $SubViewport/Camera2D
@onready var test_background : ColorRect = $SubViewport/BottomCanvas/SubViewport/TestBackground
@onready var bottom_canvas : SubViewportContainer = $SubViewport/BottomCanvas
@onready var bottom_canvas_sub_viewport : SubViewport = $SubViewport/BottomCanvas/SubViewport
@onready var raw_image : TextureRect = $SubViewport/BottomCanvas/SubViewport/RawImage
@onready var cleaned_image : TextureRect = $SubViewport/BottomCanvas/SubViewport/CleanedImage
@onready var draw_observer : DrawObserver = $SubViewport/BottomCanvas/SubViewport/DrawObserver
@onready var bubbles : Node = $SubViewport/BottomCanvas/SubViewport/Bubbles

var margin : Vector2 = Vector2(400, 400)

func _ready() -> void:
	Global.top_canvas = self
	draw_observer.top_canvas = self
	
	bottom_canvas.size = test_background.size
	camera2d.position = Vector2((test_background.size.x + margin.x) / 2, (get_viewport().size.y + margin.y) / 2)
	test_background.position = margin / 2

func load_raw_image(texture : ImageTexture) -> void:
	raw_image.texture = texture
	raw_image.size = texture.get_size()
	raw_image.position = margin / 2

func load_cleaned_image(texture : ImageTexture) -> void:
	var texture_size : Vector2 = texture.get_size()
	
	cleaned_image.texture = texture
	cleaned_image.position = margin / 2
	bottom_canvas.size = texture_size + margin
	cleaned_image.size = texture_size
	
	camera2d.position = Vector2((texture_size.x + margin.x) / 2, (get_viewport().size.y + margin.y) / 2)

func add_bubble(start_position : Vector2, end_position : Vector2, data : Dictionary = {}) -> void:
	var min_pos = Vector2(min(start_position.x, end_position.x), min(start_position.y, end_position.y))
	var max_pos = Vector2(max(start_position.x, end_position.x), max(start_position.y, end_position.y))

	if max_pos - min_pos < Vector2(10,10):
		push_error("The bubble is too small")
		return
	
	var bubble : Bubble = Global.bubble_scene.instantiate()
	
	bubbles.add_child(bubble)
	
	if data.is_empty():
		bubble.init(min_pos, max_pos - min_pos)
	else:
		bubble.load(data)
		
	Global.bubble_added.emit(bubble)

func add_boxes(boxes : Array) -> void:
	for box : Dictionary in boxes:
		var width = abs((box['x2'] - box['x1']))
		var height = abs((box['y2'] - box['y1']))
		
		add_bubble(Vector2(box['x1'], box['y1']), Vector2(box['x1'], box['y1']) + Vector2(width, height))

func remove_bubble(bubble : Bubble):
	if bubble == Global.focused_bubble:
		Global.focused_bubble = null
	
	bubble.queue_free()
	Global.bubble_removed.emit(bubble)

func bring_forward(bubble : Bubble) -> bool:
	if bubble.scene_hierarchy_index + 1 == bubbles.get_child_count():
		return false
	else:
		bubble.update_scene_hierarchy_index(bubble.scene_hierarchy_index + 1)
	return true

func bring_backward(bubble : Bubble) -> bool:
	if bubble.scene_hierarchy_index == 0:
		return false
	else:
		bubble.update_scene_hierarchy_index(bubble.scene_hierarchy_index - 1)
	return true

func clear() -> void:
	for bubble in bubbles.get_children():
		remove_bubble(bubble)

func show_raw(status : bool) -> void:
	raw_image.visible = status

func get_image() -> Image:
	var raw_visible : bool = raw_image.visible
	raw_image.hide()
	
	for bubble : Bubble in bubbles.get_children():
		bubble.can_draw = false
	
	await RenderingServer.frame_post_draw

	var image : Image = bottom_canvas_sub_viewport.get_texture().get_image()
	
	for bubble : Bubble in bubbles.get_children():
		bubble.can_draw = true
	
	raw_image.visible = raw_visible
	
	return image.get_region(Rect2i(margin / 2, raw_image.size))

func to_dictionary() -> Dictionary:
	return {
		'bubbles': bubbles.get_children().map(func(bubble): return bubble.to_dictionary())
	}

func load(data : Dictionary) -> void:
	for bubble : Dictionary in data['bubbles']:
		add_bubble(bubble['position'], bubble['position'] + bubble['size'], bubble)
