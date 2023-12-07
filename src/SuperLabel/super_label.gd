extends Control

@onready var sub_viewport : SubViewport = $SubViewport
@onready var text : Control = $SubViewport/Text
@onready var texture_rect : TextureRect = $TextureRect

var move : Move = Move.new()
var rotation_node : Rotation = Rotation.new()

var focus : bool = false : get = _get_focus

signal focused(node : Control)

func _ready():
	move.target = self
	rotation_node.target = self
	
	add_child(rotation_node)
	
	resized.connect(readjust_size)

	readjust_size()

func _input(event):
	move.input(event)

func _draw():
	if focus:
		var left = text.style_box.get_margin(SIDE_LEFT)
		var right = text.style_box.get_margin(SIDE_RIGHT)
		var top = text.style_box.get_margin(SIDE_TOP)
		var bottom = text.style_box.get_margin(SIDE_BOTTOM)
		# draw content margin rect
		draw_rect(Rect2(Vector2(left, top), size - Vector2(right + left, bottom + top)), Color.BLUE, false, 3)
		# draw rotation rect
		draw_rect(Rect2(rotation_node.position, rotation_node.size), Color.RED)
		# draw text rect
		draw_rect(Rect2(Vector2.ZERO, size), Color.RED, false, 3)
	else:
		# draw text rect
		draw_rect(Rect2(Vector2.ZERO, size), Color(Color.RED, 0.3), false, 3)

func init(_position : Vector2, _size : Vector2) -> void:
	self.position = _position
	size = _size

func readjust_size():
	sub_viewport.size = size
	text.size = size
	texture_rect.size = size
	
	pivot_offset = size / 2
	rotation_node.readjust_size()
	
	text._shape()

func _get_focus() -> bool:
	return focus

func set_focus(value : bool = true, emit : bool = true) -> void:
	focus = value
	queue_redraw()
	emit_signal('focused', self) if emit else null

func convert_to_degrees(value : float):
	value = int(rad_to_deg(value))
	if value < 0:
		value = 360 + value
	return value

func set_rotation_text(value : float):
	value = convert_to_degrees(value)
	rotation_degrees = value
#	emit_signal('rotation_changed', value)
