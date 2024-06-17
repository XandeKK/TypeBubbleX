extends VBoxContainer

var text_style : TextStyle : set = set_text_style

@onready var start_input : _Input = $ScrollContainer/MarginContainer/VBoxContainer/StartInput
@onready var end_input : _Input = $ScrollContainer/MarginContainer/VBoxContainer/EndInput
@onready var bold_check_button : CheckButton = $ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/BoldCheckButton
@onready var italic_check_button : CheckButton = $ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/ItalicCheckButton
@onready var font_input : LineEdit = $ScrollContainer/MarginContainer/VBoxContainer/FontInputDropDown
@onready var font_size_input : _Input = $ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer2/FontSizeInput
@onready var input_color : _InputColor = $ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer2/InputColor
@onready var uppercase_check_button : CheckButton = $ScrollContainer/MarginContainer/VBoxContainer/UppercaseCheckButton

func set_text_style(value : TextStyle) -> void:
	text_style = value
	
	start_input.set_value(text_style.start)
	end_input.set_value(text_style.end)
	bold_check_button.button_pressed = text_style.bold
	italic_check_button.button_pressed = text_style.italic
	font_input.text = text_style.font_name
	font_size_input.set_value(text_style.font_size)
	input_color.set_color(text_style.color)
	uppercase_check_button.button_pressed = text_style.uppercase
	
	font_input.callable_search = search_font
	font_input.list = FontConfigManager.fonts
	font_input.key = 'font'

func search_font(font : Dictionary, new_text : String):
	return font['font'].to_lower().contains(new_text) or \
		font['nickname'] != null and font['nickname'].to_lower().contains(new_text)

func _on_start_input_changed(value : int):
	text_style.start = value

func _on_end_input_changed(value : int):
	text_style.end = value

func _on_bold_check_button_toggled(toggled_on : bool):
	text_style.bold = toggled_on

func _on_italic_check_button_toggled(toggled_on : bool):
	text_style.italic = toggled_on

func _on_font_input_drop_down_changed(value : String):
	text_style.font_name = value
	text_style.font_settings = FontConfigManager.fonts[value]

func _on_font_size_input_changed(value : int):
	text_style.font_size = value

func _on_input_color_changed(value : Color):
	text_style.color = value

func _on_uppercase_check_button_toggled(toggled_on : bool):
	text_style.uppercase = toggled_on
