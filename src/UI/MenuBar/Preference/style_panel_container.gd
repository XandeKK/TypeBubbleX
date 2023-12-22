extends PanelContainer

@export var style : Preference.Styles

@onready var style_label : Label = $VBoxContainer/StyleLabel
@onready var default_font_input : LineEdit = $VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/DefaultFontInputWithDropDown
@onready var font_size_input : LineEdit = $VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/FontSizeInput

func _ready():
	style_label.text = Preference.styles_string[style]
	font_size_input.text = str(Preference.styles[style].font_size)

	default_font_input.text = Preference.styles[style].default_font if Preference.styles[style].default_font else ''
	default_font_input.callable_search = search_font
	default_font_input.list = FontConfigManager.fonts
	default_font_input.key = 'font'
	
	check_font()
	
	FontConfigManager.fonts_changed.connect(check_font)

func search_font(font : Dictionary, new_text : String):
	return font['font'].to_lower().contains(new_text) or \
		font['nickname'] != null and font['nickname'].to_lower().contains(new_text)

func check_font() -> void:
	if FontConfigManager.fonts.has(default_font_input.text):
		return
	
	Preference.styles[style].default_font = null
	default_font_input.text = ''

func _on_default_font_input_with_drop_down_changed(value):
	Preference.styles[style].default_font = value
	Preference.save_configuration()

func _on_font_size_input_changed(value):
	Preference.styles[style].font_size = value
	Preference.save_configuration()
