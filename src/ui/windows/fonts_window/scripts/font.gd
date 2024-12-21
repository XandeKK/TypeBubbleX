extends PanelContainer

@onready var font_name_label : Label = $MarginContainer/VBoxContainer/FontNameLabel
@onready var example_label : Label = $MarginContainer/VBoxContainer/Example
@onready var check_box : CheckBox = $MarginContainer/CheckBox
@onready var font : Button = $Font

var font_name : String = '' : set = _set_font_name
var selected : bool = false : set = _set_selected
var show_font : bool = false : set = _show_font

func _set_font_name(value : String) -> void:
	font_name = value
	font_name_label.text = value

func _set_selected(value : bool) -> void:
	selected = value
	
	check_box.button_pressed = value
	font.set_pressed_no_signal(value)

func _show_font(value : bool) -> void:
	show_font = value
	if show_font:
		example_label.show()
		var font_variation : FontVariation = FontConfigManager.load_regular_font(font_name)
		example_label.add_theme_font_override('font', font_variation)

func set_example(value : String) -> void:
	example_label.text = value

func set_font_size(value : int) -> void:
	example_label.add_theme_font_size_override('font_size', value)

func _on_font_toggled(toggled_on : bool) -> void:
	check_box.button_pressed = toggled_on
	
	if toggled_on:
		FontConfigManager.add_font(font_name)
	else:
		FontConfigManager.remove_font(font_name)
	
	FontConfigManager.save_configuration()
