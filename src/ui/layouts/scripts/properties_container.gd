extends PanelContainer

@onready var font : AutoCompleteBox = $ScrollContainer/VBoxContainer/Font
@onready var font_size : NumberBox = $ScrollContainer/VBoxContainer/HBoxContainer/FontSize
@onready var color : ColorPickerButton = $ScrollContainer/VBoxContainer/HBoxContainer/Color
@onready var bold : ButtonWithIcon = $ScrollContainer/VBoxContainer/HBoxContainer2/Bold
@onready var italic : ButtonWithIcon = $ScrollContainer/VBoxContainer/HBoxContainer2/Italic
@onready var uppercase : ButtonWithIcon = $ScrollContainer/VBoxContainer/HBoxContainer2/Uppercase
@onready var alignment_left : ButtonWithIcon = $ScrollContainer/VBoxContainer/HBoxContainer9/HBoxContainer5/AlignmentLeft
@onready var alignment_center : ButtonWithIcon = $ScrollContainer/VBoxContainer/HBoxContainer9/HBoxContainer5/AlignmentCenter
@onready var alignment_right : ButtonWithIcon = $ScrollContainer/VBoxContainer/HBoxContainer9/HBoxContainer5/AlignmentRight
@onready var alignment_bottom : ButtonWithIcon = $ScrollContainer/VBoxContainer/HBoxContainer9/HBoxContainer4/AlignmentBottom
@onready var alignment_middle : ButtonWithIcon = $ScrollContainer/VBoxContainer/HBoxContainer9/HBoxContainer4/AlignmentMiddle
@onready var alignment_top : ButtonWithIcon = $ScrollContainer/VBoxContainer/HBoxContainer9/HBoxContainer4/AlignmentTop
@onready var rotation_input : NumberBox = $ScrollContainer/VBoxContainer/HBoxContainer6/Rotation
@onready var tracking : NumberBox = $ScrollContainer/VBoxContainer/HBoxContainer3/HBoxContainer3/Tracking
@onready var leading : NumberBox = $ScrollContainer/VBoxContainer/HBoxContainer3/HBoxContainer4/Leading
@onready var padding_left : NumberBox = $ScrollContainer/VBoxContainer/HBoxContainer7/HBoxContainer3/PaddingLeft
@onready var padding_right : NumberBox = $ScrollContainer/VBoxContainer/HBoxContainer7/HBoxContainer4/PaddingRight
@onready var padding_bottom : NumberBox = $ScrollContainer/VBoxContainer/HBoxContainer8/HBoxContainer3/PaddingBottom
@onready var padding_top : NumberBox = $ScrollContainer/VBoxContainer/HBoxContainer8/HBoxContainer4/PaddingTop

var bubble : Bubble

func _ready() -> void:
	Global.bubble_focused.connect(_on_bubble_focused)
	set_editable(false)
	
	FontConfigManager.fonts_changed.connect(_on_fonts_changed)
	_on_fonts_changed()

func set_editable(value : bool) -> void:
	font.editable = value
	font_size.modifiable = value
	color.disabled = not value
	bold.disabled = not value
	italic.disabled = not value
	uppercase.disabled = not value
	alignment_left.disabled = not value
	alignment_center.disabled = not value
	alignment_right.disabled = not value
	alignment_bottom.disabled = not value
	alignment_middle.disabled = not value
	alignment_top.disabled = not value
	rotation_input.modifiable = value
	tracking.modifiable = value
	leading.modifiable = value
	padding_right.modifiable = value
	padding_left.modifiable = value
	padding_top.modifiable = value
	padding_bottom.modifiable = value
	
	if bubble != null and bubble.rotation_changed.is_connected(_on_rotation_changed):
		bubble.rotation_changed.disconnect(_on_rotation_changed)

func clear() -> void:
	font.text = ''
	font_size.value = 0
	color.color = Color.BLACK
	bold.set_pressed_no_signal(false)
	italic.set_pressed_no_signal(false)
	uppercase.set_pressed_no_signal(false)
	alignment_left.set_pressed_no_signal(false)
	alignment_center.set_pressed_no_signal(false)
	alignment_right.set_pressed_no_signal(false)
	alignment_bottom.set_pressed_no_signal(false)
	alignment_middle.set_pressed_no_signal(false)
	alignment_top.set_pressed_no_signal(false)
	rotation_input.value = 0
	tracking.value = 0
	leading.value = 0
	padding_right.value = 0
	padding_left.value = 0
	padding_top.value = 0
	padding_bottom.value = 0

func _on_bubble_focused(value : Bubble) -> void:
	if value == null:
		set_editable(false)
		bubble = value
		clear()
		return
	
	bubble = value
	
	set_editable(true)
	
	font.text = bubble.text.font_name
	font_size.value = bubble.text.font_size
	color.color = bubble.text.color
	bold.set_pressed_no_signal(bubble.text.bold)
	italic.set_pressed_no_signal(bubble.text.italic)
	uppercase.set_pressed_no_signal(bubble.text.uppercase)
	alignment_left.set_pressed_no_signal(bubble.text.horizontal_alignment == HORIZONTAL_ALIGNMENT_LEFT)
	alignment_center.set_pressed_no_signal(bubble.text.horizontal_alignment == HORIZONTAL_ALIGNMENT_CENTER)
	alignment_right.set_pressed_no_signal(bubble.text.horizontal_alignment == HORIZONTAL_ALIGNMENT_RIGHT)
	alignment_bottom.set_pressed_no_signal(bubble.text.vertical_alignment == VERTICAL_ALIGNMENT_BOTTOM)
	alignment_middle.set_pressed_no_signal(bubble.text.vertical_alignment == VERTICAL_ALIGNMENT_CENTER)
	alignment_top.set_pressed_no_signal(bubble.text.vertical_alignment == VERTICAL_ALIGNMENT_TOP)
	rotation_input.value = bubble.rotation_degrees
	tracking.value = bubble.text.tracking
	leading.value = bubble.text.leading
	padding_right.value = bubble.text.style_box.content_margin_right
	padding_left.value = bubble.text.style_box.content_margin_left
	padding_top.value = bubble.text.style_box.content_margin_top
	padding_bottom.value = bubble.text.style_box.content_margin_bottom
	
	bubble.rotation_changed.connect(_on_rotation_changed)

func _on_fonts_changed() -> void:
	font.suggestions_dict = FontConfigManager.fonts

func _on_rotation_changed(value : float) -> void:
	rotation_input.value = value

func set_horizontal_alignment(value : HorizontalAlignment) -> void:
	bubble.text.horizontal_alignment = value

func set_vertical_alignment(value : VerticalAlignment) -> void:
	bubble.text.vertical_alignment = value

func _on_font_value_changed(new_text: String) -> void:
	if bubble == null:
		return
	
	bubble.text.font_name = new_text
	bubble.text.font_settings = FontConfigManager.fonts[new_text]

func _on_font_size_value_changed(value: float) -> void:
	if bubble == null:
		return
	
	bubble.text.font_size = value as int

func _on_color_color_changed(_color: Color) -> void:
	if bubble == null:
		return
	
	bubble.text.color = _color

func _on_bold_toggled(toggled_on: bool) -> void:
	if bubble == null:
		return
	
	bubble.text.bold = toggled_on

func _on_italic_toggled(toggled_on: bool) -> void:
	if bubble == null:
		return
	
	bubble.text.italic = toggled_on

func _on_uppercase_toggled(toggled_on: bool) -> void:
	if bubble == null:
		return
	
	bubble.text.uppercase = toggled_on

func _on_alignment_left_toggled(toggled_on: bool) -> void:
	if bubble == null:
		return
	
	if not toggled_on:
		alignment_left.set_pressed_no_signal(true)
		return
	
	set_horizontal_alignment(HORIZONTAL_ALIGNMENT_LEFT)
	
	alignment_center.set_pressed_no_signal(false)
	alignment_right.set_pressed_no_signal(false)

func _on_alignment_center_toggled(toggled_on: bool) -> void:
	if bubble == null:
		return
	
	if not toggled_on:
		alignment_center.set_pressed_no_signal(true)
		return
	
	set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER)
	
	alignment_left.set_pressed_no_signal(false)
	alignment_right.set_pressed_no_signal(false)

func _on_alignment_right_toggled(toggled_on: bool) -> void:
	if bubble == null:
		return
	
	if not toggled_on:
		alignment_right.set_pressed_no_signal(true)
		return
	
	set_horizontal_alignment(HORIZONTAL_ALIGNMENT_RIGHT)
	
	alignment_left.set_pressed_no_signal(false)
	alignment_center.set_pressed_no_signal(false)

func _on_alignment_bottom_toggled(toggled_on: bool) -> void:
	if bubble == null:
		return
	
	if not toggled_on:
		alignment_bottom.set_pressed_no_signal(true)
		return
	
	set_vertical_alignment(VERTICAL_ALIGNMENT_BOTTOM)
	
	alignment_top.set_pressed_no_signal(false)
	alignment_middle.set_pressed_no_signal(false)

func _on_alignment_middle_toggled(toggled_on: bool) -> void:
	if bubble == null:
		return
	
	if not toggled_on:
		alignment_middle.set_pressed_no_signal(true)
		return
	
	set_vertical_alignment(VERTICAL_ALIGNMENT_CENTER)
	
	alignment_top.set_pressed_no_signal(false)
	alignment_bottom.set_pressed_no_signal(false)

func _on_alignment_top_toggled(toggled_on: bool) -> void:
	if bubble == null:
		return
	
	if not toggled_on:
		alignment_top.set_pressed_no_signal(true)
		return
	
	set_vertical_alignment(VERTICAL_ALIGNMENT_TOP)
	
	alignment_middle.set_pressed_no_signal(false)
	alignment_bottom.set_pressed_no_signal(false)

func _on_rotation_value_changed(value: float) -> void:
	if bubble == null:
		return
	
	bubble.rotation_degrees = value

func _on_tracking_value_changed(value: float) -> void:
	if bubble == null:
		return
	
	bubble.text.tracking = value as int

func _on_leading_value_changed(value: float) -> void:
	if bubble == null:
		return
	
	bubble.text.leading = value as int

func _on_padding_right_value_changed(value: float) -> void:
	if bubble == null:
		return
	
	bubble.set_content_margin(SIDE_RIGHT, value)

func _on_padding_left_value_changed(value: float) -> void:
	if bubble == null:
		return
	
	bubble.set_content_margin(SIDE_LEFT, value)

func _on_padding_top_value_changed(value: float) -> void:
	if bubble == null:
		return
	
	bubble.set_content_margin(SIDE_TOP, value)

func _on_padding_bottom_value_changed(value: float) -> void:
	if bubble == null:
		return
	
	bubble.set_content_margin(SIDE_BOTTOM, value)
