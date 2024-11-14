class_name Bubble
extends Control

@warning_ignore("unused_signal")
signal rotation_changed(value : float)

@onready var first_sub_viewport : SubViewport = $FirstSubViewport
@onready var text : Text = $FirstSubViewport/Text
@onready var final_texture_rect : TextureRect = $FinalTextureRect

var draw_bubble : DrawBubble = DrawBubble.new(self)
var move_bubble : MoveBubble = MoveBubble.new(self)
var rotation_bubble : RotationBubble = RotationBubble.new(self)
var blur_bubble : BlurBubble = null 
var motion_blur_bubble : MotionBlurBubble = null
var perspective_bubble : PerspectiveBubble = null
var mask_bubble : MaskBubble = null
var text_path_2d : TextPath2D = null
var sub_viewport_manager : SubViewportManager

var is_focused : bool = false
var scene_hierarchy_index : int

func _ready() -> void:
	sub_viewport_manager = SubViewportManager.new(first_sub_viewport)
	sub_viewport_manager.reconnected.connect(reconnect_sub_viewport)
	reconnect_sub_viewport()
	
	scene_hierarchy_index = get_tree().get_node_count_in_group('Bubbles')
	add_to_group("Bubbles")

func _exit_tree():
	draw_bubble.free()
	text.free()
	move_bubble.free()
	rotation_bubble.free()
	
	if mask_bubble != null:
		mask_bubble.free()
	
	if perspective_bubble != null:
		perspective_bubble.free()
	
	if text_path_2d != null:
		text_path_2d.free()
	
	if sub_viewport_manager != null:
		sub_viewport_manager.free()

func _gui_input(event: InputEvent) -> void:
	move_bubble.gui_input(event)

func _on_resized() -> void:
	text.size = size
	first_sub_viewport.size = size
	sub_viewport_manager.resize_sub_viewports(size)
	final_texture_rect.size = size
	pivot_offset = size / 2
	
	text._shape()

func set_focus(value : bool) -> void:
	is_focused = value
	rotation_bubble.visible = is_focused
	
	draw_bubble.queue_redraw()
	rotation_bubble.queue_redraw()
	
	if is_focused:
		Global.focused_bubble = self
		get_parent().move_child(self, -1)
	elif not is_focused and get_index() != scene_hierarchy_index:
		get_parent().move_child(self, scene_hierarchy_index)

func delete() -> void:
	remove_from_group("Bubbles")
	Global.update_scene_hierarchy_indices()
	queue_free()

func reconnect_sub_viewport() -> void:
	final_texture_rect.texture = sub_viewport_manager.get_texture()

func update_scene_hierarchy_index(new_index: int) -> void:
	scene_hierarchy_index = new_index
	get_parent().move_child(self, scene_hierarchy_index)

func add_blur() -> void:
	if blur_bubble == null:
		var sub_viewport_blur : SubViewport = Global.sub_viewport_blur_scene.instantiate()
		add_child(sub_viewport_blur)
		sub_viewport_manager.add(sub_viewport_blur)
		blur_bubble = BlurBubble.new(self, sub_viewport_blur)

func remove_blur() -> void:
	if blur_bubble != null:
		sub_viewport_manager.remove(blur_bubble.sub_viewport_blur.index)
		blur_bubble.free()
		blur_bubble = null

func add_motion_blur() -> void:
	if motion_blur_bubble == null:
		var sub_viewport_motion_blur : SubViewport = Global.sub_viewport_motion_blur_scene.instantiate()
		add_child(sub_viewport_motion_blur)
		sub_viewport_manager.add(sub_viewport_motion_blur)
		motion_blur_bubble = MotionBlurBubble.new(self, sub_viewport_motion_blur)

func remove_motion_blur() -> void:
	if motion_blur_bubble != null:
		sub_viewport_manager.remove(motion_blur_bubble.sub_viewport_motion_blur.index)
		motion_blur_bubble.free()
		motion_blur_bubble = null

func add_perspective() -> void:
	if perspective_bubble == null:
		var sub_viewport_perspective : SubViewport = Global.sub_viewport_perspective_scene.instantiate()
		add_child(sub_viewport_perspective)
		sub_viewport_manager.add(sub_viewport_perspective)
		perspective_bubble = PerspectiveBubble.new(self, sub_viewport_perspective)

func remove_perspective() -> void:
	if perspective_bubble != null:
		sub_viewport_manager.remove(perspective_bubble.sub_viewport_perspective.index)
		perspective_bubble.free()
		perspective_bubble = null

func add_mask() -> void:
	if mask_bubble == null:
		mask_bubble = Global.mask_bubble_scene.instantiate()
		mask_bubble.init(self)
		remove_child(final_texture_rect)
		mask_bubble.add_child(final_texture_rect)

func remove_mask() -> void:
	if mask_bubble != null:
		mask_bubble.remove_child(final_texture_rect)
		add_child(final_texture_rect)
		mask_bubble.free()
		mask_bubble = null

func add_text_path_2d() -> void:
	if text_path_2d == null:
		text_path_2d = TextPath2D.new(self)
		text.curve = text_path_2d.curve
		text.curve.add_point(Vector2(0, size.y / 2))
		text.curve.add_point(Vector2(size.x, size.y / 2))
		add_child(text_path_2d)

func remove_text_path_2d() -> void:
	if text_path_2d != null:
		remove_child(text_path_2d)
		text.curve = null
		text_path_2d.free()
		text_path_2d = null

func to_dictionary() -> Dictionary:
	var data = {
		'position': position,
		'size': size,
		'rotation_degrees': rotation_degrees,
		'text': text.to_dictionary(),
	}
	
	if perspective_bubble != null:
		data['perspective_bubble'] = perspective_bubble.to_dictionary()
	
	if mask_bubble != null:
		data['mask_bubble'] = mask_bubble.to_dictionary()
	
	if blur_bubble != null:
		data['blur_bubble'] = blur_bubble.to_dictionary()
	
	if motion_blur_bubble != null:
		data['motion_blur_bubble'] = motion_blur_bubble.to_dictionary()

	if text_path_2d != null:
		data['text_path_2d'] = text_path_2d.to_dictionary()
	
	return data

func load(data : Dictionary) -> void:
	position = data['position']
	rotation_degrees = data['rotation_degrees']
	size = data['size']
	text.load(data['text'])
	
	if data.has('perspective_bubble'):
		add_perspective()
		perspective_bubble.load(data['perspective_bubble'])
	
	if data.has('mask_bubble'):
		add_mask()
		mask_bubble.load(data['mask_bubble'])
	
	if data.has('blur_bubble'):
		add_blur()
		blur_bubble.load(data['blur_bubble'])
	
	if data.has('motion_blur_bubble'):
		add_motion_blur()
		motion_blur_bubble.load(data['motion_blur_bubble'])
	
	if data.has('text_path_2d'):
		add_text_path_2d()
		text_path_2d.load(data['text_path_2d'])
