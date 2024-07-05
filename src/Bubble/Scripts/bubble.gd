extends Control
class_name Bubble

@onready var mask : Mask
@onready var sub_viewport_container : SubViewportContainer = $SubViewportContainer
@onready var sub_viewport : SubViewport = $SubViewportContainer/SubViewport
@onready var text : Text = $SubViewportContainer/SubViewport/Text
@onready var text_path : TextPath2D = $TextPath2D

var move_bubble : MoveBubble = MoveBubble.new()
var rotation_bubble : RotationBubble = RotationBubble.new()
var perspective : Perspective = Perspective.new()

var focus : bool = false : get = _get_focus
var can_draw : bool = true : set = _set_can_draw

signal focused(node : Bubble)
signal focus_changed
signal rotation_changed(value)

func _ready():
	move_bubble.bubble = self
	rotation_bubble.bubble = self
	perspective.bubble = self
	text_path.text = text
	
	add_child(rotation_bubble)
	add_child(perspective)
	
	resized.connect(readjust_size)

	readjust_size()

func _input(event):
	move_bubble.input(event)

func _draw():
	if not can_draw:
		return

	if focus:
		draw_focused_elements()
	else:
		draw_inactive_text_rect()

func draw_focused_elements():
	var left = text.style_box.get_margin(SIDE_LEFT)
	var right = text.style_box.get_margin(SIDE_RIGHT)
	var top = text.style_box.get_margin(SIDE_TOP)
	var bottom = text.style_box.get_margin(SIDE_BOTTOM)
	
	# Draw content margin rect
	var content_rect = Rect2(Vector2(left, top), size - Vector2(right, bottom))
	draw_polyline(create_packed_vector(content_rect), Preference.colors.padding.active, 1, true)
	
	# Draw rotation rect
	var rotation_rect = Rect2(rotation_bubble.position, rotation_bubble.size)
	draw_rect(rotation_rect, Preference.colors.bubble.active)
	
	# Draw text rect
	var text_rect = Rect2(Vector2.ZERO, size)
	draw_polyline(create_packed_vector(text_rect), Preference.colors.bubble.active, 1, true)

func draw_inactive_text_rect():
	var text_rect = Rect2(Vector2.ZERO, size)
	draw_polyline(create_packed_vector(text_rect), Preference.colors.bubble.inactive, 1, true)

func create_packed_vector(rect : Rect2) -> PackedVector2Array:
	return PackedVector2Array([
		Vector2(rect.position),
		Vector2(rect.size.x, rect.position.y),
		Vector2(rect.size.x, rect.size.y),
		Vector2(rect.position.x, rect.size.y),
		Vector2(rect.position)
	])

func init(_position : Vector2, _size : Vector2, type : Preference.HQTypes) -> void:
	self.position = _position
	size = _size
	
	var font_name = Preference.hq_types[type]['default_font']
	
	if font_name and FontConfigManager.fonts.has(font_name):
		text.font_name = font_name
		text.font_settings = FontConfigManager.fonts[font_name]
	
	text.font_size = Preference.hq_types[type]['font_size']

func readjust_size():
	sub_viewport.size = size
	sub_viewport_container.size = size
	text.size = size
	perspective.size = size
	text_path.size = size
	
	pivot_offset = size / 2
	rotation_bubble.readjust_size()
	perspective.reset()
	
	text._shape()

func active_mask(value : bool) -> void:
	if value:
		mask = Global.mask.instantiate()
		add_child(mask)
		mask.set_deferred('size', size)
		remove_child(sub_viewport_container)
		mask.add_child(sub_viewport_container)
		
		mask.anchors_preset = PRESET_FULL_RECT
	else:
		mask.remove_child(sub_viewport_container)
		add_child(sub_viewport_container)
		move_child(sub_viewport_container, 0)
		remove_child(mask)
		mask.queue_free()
		mask = null

func _get_focus() -> bool:
	return focus

func set_focus(value : bool = true, emit : bool = true) -> void:
	focus = value
	can_draw = true
	if emit:
		emit_signal('focused', self)
	emit_signal('focus_changed')
	
	if focus:
		get_parent().move_child(self, -1)

func _set_can_draw(value : bool) -> void:
	can_draw = value
	perspective.can_draw = can_draw
	text_path.can_draw = can_draw
	queue_redraw()

func apply_rotation(value : float):
	rotation_degrees = value
	emit_signal('rotation_changed', value)

func set_content_margin(margin : Side, offset : float):
	text.set_content_margin(margin, offset)
	queue_redraw()

func to_dictionary() -> Dictionary:
	var data = {
		'position': position,
		'size': size,
		'rotation_degrees': rotation_degrees,
		'perspective': perspective.to_dictionary(),
		'text': text.to_dictionary(),
		'text_path': text_path.to_dictionary()
	}
	if mask != null:
		data['mask'] = mask.to_dictionary()
	else:
		data['mask'] = null
	
	return data

func load(data : Dictionary) -> void:
	rotation_degrees = data['rotation_degrees']
	perspective.load(data['perspective'])
	text_path.load(data['text_path'])
	
	text.load(data['text'])
	if data.has('mask') and data['mask']:
		active_mask(true)
		mask.load(data['mask'])

func _exit_tree():
	move_bubble.free()
	perspective.free()
