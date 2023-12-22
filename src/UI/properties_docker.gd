extends Panel

@export var canvas : SubViewportContainer

@onready var font_name : LineEdit = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/FontContainer/FontName
@onready var font_size : LineEdit = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/FontContainer/HBoxContainer/FontSize
@onready var color : ColorPickerButton = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/FontContainer/HBoxContainer/Color
@onready var bold : CheckButton = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/BoldItalicContainer/Bold
@onready var italic : CheckButton = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/BoldItalicContainer/Italic
@onready var leading : LineEdit = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/LeadingContainer/Leading
@onready var tracking : LineEdit = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/TrackingContainer/Tracking
@onready var alignment : OptionButton = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/AlignmentContainer/Alignment 
@onready var rotation_text : LineEdit = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/RotationContainer/Rotation
@onready var padding_top : LineEdit = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/PaddingMarginContainer/VBoxContainer/TopContainer/PaddingTop
@onready var padding_bottom : LineEdit = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/PaddingMarginContainer/VBoxContainer/BottomContainer/PaddingBottom
@onready var padding_left : LineEdit = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/PaddingMarginContainer/VBoxContainer/LeftContainer/PaddingLeft
@onready var padding_right : LineEdit = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/PaddingMarginContainer/VBoxContainer/RightContainer/PaddingRight

func _ready():
	canvas.object_focus_changed.connect(set_values)
	set_values(null)
	connect_all()

func connect_all():
	font_name.callable_search = search_font
	font_name.list = FontConfigManager.fonts
	font_name.key = 'font'
	
	font_name.changed.connect(set_font)
	font_size.changed.connect(set_font_size)
	color.color_changed.connect(set_color)
	bold.toggled.connect(set_bold)
	italic.toggled.connect(set_italic)
	tracking.changed.connect(set_tracking)
	leading.changed.connect(set_leading)
	alignment.item_selected.connect(set_alignment)
	rotation_text.changed.connect(set_rotation_text)
	padding_top.changed.connect(set_padding_top)
	padding_right.changed.connect(set_padding_right)
	padding_bottom.changed.connect(set_padding_bottom)
	padding_left.changed.connect(set_padding_left)

func blank_all():
	font_name.text = ''
	font_size.text = '0'
	color.color = Color.BLACK
	bold.button_pressed = false
	italic.button_pressed = false
	tracking.text = '0'
	leading.text = '0'
	alignment.selected = -1
	rotation_text.text = '0'
	padding_top.text = '0'
	padding_right.text = '0'
	padding_bottom.text = '0'
	padding_left.text = '0'

func set_values(node : Control):
	if not node:
		blank_all()
		return

	font_name.text = node.text.font_name
	font_size.text = str(node.text.font_size)
	color.color = node.text.color
	bold.button_pressed = node.text.bold
	italic.button_pressed = node.text.italic
	tracking.text = str(node.text.letter_spacing)
	leading.text = str(node.text.line_spacing)
	alignment.selected = node.text.horizontal_alignment
	rotation_text.text = str(node.rotation_degrees)
	padding_top.text = str(node.text.style_box.content_margin_top)
	padding_right.text = str(node.text.style_box.content_margin_right)
	padding_bottom.text = str(node.text.style_box.content_margin_bottom)
	padding_left.text = str(node.text.style_box.content_margin_left)
	
	if not node.is_connected('rotation_changed', set_input_rotation_text):
		node.rotation_changed.connect(set_input_rotation_text)

func search_font(font : Dictionary, new_text : String):
	return font['font'].to_lower().contains(new_text) or \
		font['nickname'] != null and font['nickname'].to_lower().contains(new_text)

func set_font(value : String) -> void:
	canvas.focused_object.text.font_name = value
	canvas.focused_object.text.font_settings = FontConfigManager.fonts[value]

func set_font_size(value) -> void:
	if not canvas.focused_object:
		return
	
	canvas.focused_object.text.font_size = value

func set_color(value) -> void:
	if not canvas.focused_object:
		return
	
	canvas.focused_object.text.color = value

func set_bold(value) -> void:
	if not canvas.focused_object:
		return
	
	canvas.focused_object.text.bold = value

func set_italic(value) -> void:
	if not canvas.focused_object:
		return
	
	canvas.focused_object.text.italic = value

func set_tracking(value) -> void:
	if not canvas.focused_object:
		return
	
	canvas.focused_object.text.letter_spacing = value

func set_leading(value) -> void:
	if not canvas.focused_object:
		return
	
	canvas.focused_object.text.line_spacing = value

func set_alignment(value) -> void:
	if not canvas.focused_object:
		return
	
	canvas.focused_object.text.horizontal_alignment = value

func set_rotation_text(value) -> void:
	if not canvas.focused_object:
		return
	
	canvas.focused_object.rotation_degrees = value

func set_padding_top(value) -> void:
	if not canvas.focused_object:
		return

	canvas.focused_object.set_content_margin(SIDE_TOP, value)

func set_padding_right(value) -> void:
	if not canvas.focused_object:
		return

	canvas.focused_object.set_content_margin(SIDE_RIGHT, value)

func set_padding_bottom(value) -> void:
	if not canvas.focused_object:
		return

	canvas.focused_object.set_content_margin(SIDE_BOTTOM, value)

func set_padding_left(value) -> void:
	if not canvas.focused_object:
		return

	canvas.focused_object.set_content_margin(SIDE_LEFT, value)

func set_input_rotation_text(value) -> void:
	rotation_text.text = str(value)
	rotation_text.slider.value = value
