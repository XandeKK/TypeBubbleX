extends PanelContainer

@onready var check_box : CheckBox = $VBoxContainer/CheckBox
@onready var example : Label = $VBoxContainer/Label

var font_name : String : set = _set_font_name
var selected : bool : set = _set_selected
var show_fonts : bool : set = _set_show_fonts

func _set_font_name(value : String) -> void:
	font_name = value
	check_box.text = font_name

func _set_selected(value : bool) -> void:
	selected = value
	check_box.button_pressed = selected

func _set_show_fonts(value : bool) -> void:
	show_fonts = value
	if show_fonts:
		example.show()
		var font_variation : FontVariation = FontConfigManager.load_regular_font(font_name)
		example.add_theme_font_override('font', font_variation)
		example.add_theme_font_size_override('font_size', 20)

func on_text_changed(text : String) -> void:
	example.text = text

func _on_check_box_pressed():
	if check_box.button_pressed:
		FontConfigManager.add_font(font_name)
	else:
		FontConfigManager.remove_font(font_name)

	FontConfigManager.save_configuration()
