extends Node
class_name TextStyle

var index : int 
var text : Text : set = _set_text
var start : int  : get = _get_start, set = _set_start
var end : int : get = _get_end, set = _set_end
var bold : bool : get = _get_bold, set = _set_bold
var italic : bool : get = _get_italic, set = _set_italic
var font_size : int : get = _get_font_size, set = _set_font_size
var font_name : String : get = _get_font_name, set = _set_font_name
var font_settings : Dictionary : get = _get_font_settings, set = _set_font_settings
var color : Color : get = _get_color, set = _set_color
var uppercase : bool : get = _get_uppercase, set = _set_uppercase

var text_styles_manager : TextStyleManager : set = set_text_styles_manager, get = get_text_styles_manager

func _set_text(value : Text) -> void:
	text = value

func _get_start() -> int:
	return start

func _set_start(value : int) -> void:
	start = value
	
	if text:
		text._shape()

func _get_end() -> int:
	return end

func _set_end(value : int) -> void:
	end = value
	
	if text:
		text._shape()

func _get_bold() -> bool:
	return bold

func _set_bold(value : bool) -> void:
	bold = value
	if text:
		text._shape()

func _get_italic() -> bool:
	return italic

func _set_italic(value : bool) -> void:
	italic = value
	if text:
		text._shape()

func _get_font_size() -> int:
	return font_size

func _set_font_size(value : int) -> void:
	font_size = value
	if text:
		text._shape()

func _get_font_name() -> String:
	return font_name

func _set_font_name(value : String) -> void:
	font_name = value

func _get_font_settings() -> Dictionary:
	return font_settings

func _set_font_settings(value : Dictionary) -> void:
	font_settings = value
	if text:
		text._shape()

func _get_color() -> Color:
	return color

func _set_color(value : Color) -> void:
	color = value
	if text:
		text._shape()

func _get_uppercase() -> bool:
	return uppercase

func _set_uppercase(value : bool) -> void:
	uppercase = value
	if text:
		text._shape()

func get_text_styles_manager() -> TextStyleManager:
	return text_styles_manager

func set_text_styles_manager(value : TextStyleManager) -> void:
	text_styles_manager = value

func to_dictionary() -> Dictionary:
	return {
		'start': start,
		'end': end,
		'bold': bold,
		'italic': italic,
		'font_size': font_size,
		'font_name': font_name,
		'color': color,
		'uppercase': uppercase
	}

func load(data : Dictionary) -> void:
	bold = data['bold']
	italic = data['italic']
	font_size = data['font_size']
	font_name = data['font_name']
	# I will change it to make it shareable.
	if FontConfigManager.fonts.has(font_name):
		font_settings = FontConfigManager.fonts[font_name]
	color = data['color']
	uppercase = data['uppercase']
	
