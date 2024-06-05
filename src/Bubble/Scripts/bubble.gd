extends Control
class_name Bubble

@onready var mask : Mask = $Mask
@onready var sub_viewport_container : SubViewportContainer = $Mask/SubViewportContainer
@onready var sub_viewport : SubViewport = $Mask/SubViewportContainer/SubViewport
@onready var text : Text = $Mask/SubViewportContainer/SubViewport/Text

var move_bubble : MoveBubble = MoveBubble.new()
var rotation_bubble : RotationBubble = RotationBubble.new()
var perspective : Perspective = Perspective.new()

var focus : bool = false : get = _get_focus
var can_draw : bool = true : set = _set_can_draw
var canvas : SubViewportContainer : set = _set_canvas

signal focused(node : Bubble)
signal focus_changed
signal rotation_changed(value)

func _ready():
	move_bubble.bubble = self
	rotation_bubble.bubble = self
	perspective.bubble = self
	
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
		var left = text.style_box.get_margin(SIDE_LEFT)
		var right = text.style_box.get_margin(SIDE_RIGHT)
		var top = text.style_box.get_margin(SIDE_TOP)
		var bottom = text.style_box.get_margin(SIDE_BOTTOM)
		# draw content margin rect
		draw_rect(Rect2(Vector2(left, top), size - Vector2(right + left, bottom + top)), Preference.colors.padding.active, false, 3)
		# draw rotation rect
		draw_rect(Rect2(rotation_bubble.position, rotation_bubble.size), Preference.colors.bubble.active)
		# draw text rect
		draw_rect(Rect2(Vector2.ZERO, size), Preference.colors.bubble.active, false, 3)
	else:
		# draw text rect
		draw_rect(Rect2(Vector2.ZERO, size), Preference.colors.bubble.inactive, false, 3)

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
	mask.set_deferred('size', size)
	
	pivot_offset = size / 2
	rotation_bubble.readjust_size()
	perspective.reset()
	
	text._shape()

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
	queue_redraw()

func _set_canvas(value : SubViewportContainer) -> void:
	canvas = value

func apply_rotation(value : float):
	rotation_degrees = value
	emit_signal('rotation_changed', value)

func set_content_margin(margin : Side, offset : float):
	text.set_content_margin(margin, offset)
	queue_redraw()

func to_dictionary() -> Dictionary:
	return {
		'position': position,
		'size': size,
		'rotation_degrees': rotation_degrees,
		'perspective': perspective.to_dictionary(),
		'text': text.to_dictionary()
	}

func load(data : Dictionary) -> void:
	rotation_degrees = data['rotation_degrees']
	perspective.load(data['perspective'])
	
	text.load(data['text'])

func extract_data_for_ai() -> Dictionary:
	var _text : String = text.text.replace('-\n', '').replace("\n", ' ').replace('  ', ' ')
	var current_font : FontVariation
	
	if text.bold and text.italic:
		current_font = text.font_settings['bold-italic']
	elif text.bold:
		current_font = text.font_settings['bold']
	elif text.italic:
		current_font = text.font_settings['italic']
	else:
		current_font = text.font_settings['regular']

	var get_string_size : Callable = func(word) -> Array:
		var string_size : Vector2 = current_font.get_string_size(word, HORIZONTAL_ALIGNMENT_CENTER, -1, text.font_size)
		return [string_size.x, string_size.y]
		
	var data : Dictionary = {
		'image': sub_viewport.get_texture().get_image(),
		'text': _text,
		'font_size': text.font_size,
		'font_name': text.font_name,
		'words_size': Array(_text.split(' ')).map(func(word): return get_string_size.call(word)),
		'size': {
			'x': size.x,
			'y': size.y
		}
	}
	
	return data

func _exit_tree():
	move_bubble.free()
	perspective.free()
