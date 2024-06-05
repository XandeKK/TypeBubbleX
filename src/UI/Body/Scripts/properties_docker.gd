extends PanelContainer

@onready var font_input_drop_down : InputDropDown = $ScrollContainer/MarginContainer/VBoxContainer/FontInputDropDown
@onready var font_size_input : _Input = $ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/FontSizeInput
@onready var color_input : _InputColor = $ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/ColorInput
@onready var bold_check_button : CheckButton = $ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer2/BoldCheckButton
@onready var italic_check_button : CheckButton = $ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer2/ItalicCheckButton
@onready var uppercase_check_button : CheckButton = $ScrollContainer/MarginContainer/VBoxContainer/UppercaseCheckButton
@onready var leading_input : _Input = $ScrollContainer/MarginContainer/VBoxContainer/LeadingInput
@onready var tracking_input : _Input = $ScrollContainer/MarginContainer/VBoxContainer/TrackingInput
@onready var alignment_option_button : OptionButton = $ScrollContainer/MarginContainer/VBoxContainer/AligmentHBoxContainer/AlignmentOptionButton
@onready var rotation_input : _Input = $ScrollContainer/MarginContainer/VBoxContainer/RotationInput

# Padding
@onready var top_input : _Input = $ScrollContainer/MarginContainer/VBoxContainer/GridContainer/TopInput
@onready var left_input : _Input = $ScrollContainer/MarginContainer/VBoxContainer/GridContainer/LeftInput
@onready var right_input : _Input = $ScrollContainer/MarginContainer/VBoxContainer/GridContainer/RightInput
@onready var bottom_input : _Input = $ScrollContainer/MarginContainer/VBoxContainer/GridContainer/BottomInput

func _ready():
	if Global.canvas:
		connect_canvas()
	else:
		Global.canvas_setted.connect(connect_canvas)

	set_values(null)
	
	font_input_drop_down.callable_search = search_font
	font_input_drop_down.list = FontConfigManager.fonts
	font_input_drop_down.key = 'font'

func search_font(font : Dictionary, new_text : String):
	return font['font'].to_lower().contains(new_text) or \
		font['nickname'] != null and font['nickname'].to_lower().contains(new_text)

func connect_canvas() -> void:
	Global.canvas.bubble_focus_changed.connect(set_values)

func blank_all():
	font_input_drop_down.text = ''
	font_size_input.set_value(0)
	color_input.set_color(Color.BLACK)
	bold_check_button.button_pressed = false
	italic_check_button.button_pressed = false
	uppercase_check_button.button_pressed = false
	leading_input.set_value(0)
	tracking_input.set_value(0)
	alignment_option_button.selected = -1
	rotation_input.set_value(0)
	top_input.set_value(0)
	left_input.set_value(0)
	right_input.set_value(0)
	bottom_input.set_value(0)
	
	font_input_drop_down.editable = false
	font_size_input.editable = false
	color_input.disabled = true
	bold_check_button.disabled = true
	italic_check_button.disabled = true
	uppercase_check_button.disabled = true
	leading_input.editable = false
	tracking_input.editable = false
	alignment_option_button.disabled = true
	rotation_input.editable = false
	top_input.editable = false
	left_input.editable = false
	right_input.editable = false
	bottom_input.editable = false

func set_values(node : Bubble):
	if not node:
		blank_all()
		return
	
	color_input.add_swatches(Preference.colors.swatches.keys())
	
	font_input_drop_down.editable = true
	font_size_input.editable = true
	color_input.disabled = false
	bold_check_button.disabled = false
	italic_check_button.disabled = false
	uppercase_check_button.disabled = false
	leading_input.editable = true
	tracking_input.editable = true
	alignment_option_button.disabled = false
	rotation_input.editable = true
	top_input.editable = true
	left_input.editable = true
	right_input.editable = true
	bottom_input.editable = true

	font_input_drop_down.text = node.text.font_name
	font_size_input.set_value(node.text.font_size)
	color_input.set_color(node.text.color)
	bold_check_button.button_pressed = node.text.bold
	italic_check_button.button_pressed = node.text.italic
	uppercase_check_button.button_pressed = node.text.uppercase
	leading_input.set_value(node.text.line_spacing)
	tracking_input.set_value(node.text.letter_spacing)
	alignment_option_button.selected = node.text.horizontal_alignment
	rotation_input.set_value(node.rotation_degrees)
	top_input.set_value(node.text.style_box.content_margin_top)
	left_input.set_value(node.text.style_box.content_margin_left)
	right_input.set_value(node.text.style_box.content_margin_right)
	bottom_input.set_value(node.text.style_box.content_margin_bottom)
	
	if not node.is_connected('rotation_changed', set_input_rotation_value):
		node.rotation_changed.connect(set_input_rotation_value)

func set_input_rotation_value(value) -> void:
	rotation_input.set_value(value)

func _on_font_input_drop_down_changed(value):
	Global.canvas.focused_bubble.text.font_name = value
	Global.canvas.focused_bubble.text.font_settings = FontConfigManager.fonts[value]

func _on_font_size_input_changed(value):
	Global.canvas.focused_bubble.text.font_size = value

func _on_color_input_changed(value):
	Global.canvas.focused_bubble.text.color = value

func _on_bold_check_button_toggled(toggled_on):
	Global.canvas.focused_bubble.text.bold = toggled_on

func _on_italic_check_button_toggled(toggled_on):
	Global.canvas.focused_bubble.text.italic = toggled_on

func _on_uppercase_check_button_toggled(toggled_on):
	Global.canvas.focused_bubble.text.uppercase = toggled_on

func _on_leading_input_changed(value):
	Global.canvas.focused_bubble.text.line_spacing = value

func _on_tracking_input_changed(value):
	Global.canvas.focused_bubble.text.letter_spacing = value

func _on_alignment_option_button_item_selected(index):
	Global.canvas.focused_bubble.text.horizontal_alignment = index

func _on_rotation_input_changed(value):
	Global.canvas.focused_bubble.rotation_degrees = value

func _on_top_input_changed(value):
	Global.canvas.focused_bubble.set_content_margin(SIDE_TOP, value)

func _on_left_input_changed(value):
	Global.canvas.focused_bubble.set_content_margin(SIDE_LEFT, value)

func _on_right_input_changed(value):
	Global.canvas.focused_bubble.set_content_margin(SIDE_RIGHT, value)

func _on_bottom_input_changed(value):
	Global.canvas.focused_bubble.set_content_margin(SIDE_BOTTOM, value)
