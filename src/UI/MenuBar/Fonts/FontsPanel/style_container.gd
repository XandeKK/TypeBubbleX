extends PanelContainer
class_name StyleContainer

enum Styles {
	REGULAR,
	BOLD,
	ITALIC,
	BOLD_ITALIC
}

@export var style : Styles

@onready var example_label : Label = $MarginContainer/VBoxContainer/ExampleLabel
@onready var embolden_input : _Input = $MarginContainer/VBoxContainer/EmboldenInput
@onready var spacing_glyh_input : _Input = $MarginContainer/VBoxContainer/SpacingGlyphInput
@onready var skew_input : _Input = $MarginContainer/VBoxContainer/SkewInput

var font_name : String : set = _set_font_name
var font : FontVariation : set = _set_font
var font_size : int : set = _set_font_size
var style_name : String

func _ready():
	example_label.add_theme_font_size_override('font_size', 50)
	
	match style:
		Styles.REGULAR:
			style_name = 'regular'
		Styles.ITALIC:
			style_name = 'italic'
		Styles.BOLD:
			style_name = 'bold'
		Styles.BOLD_ITALIC:
			style_name = 'bold-italic'

func _set_font(value : FontVariation) -> void:
	font = value
	
	example_label.add_theme_font_override('font', font)
	
	embolden_input.default_value = 0
	spacing_glyh_input.default_value = 0
	skew_input.default_value = 0
	
	embolden_input.set_value(font.variation_embolden)
	spacing_glyh_input.set_value(font.spacing_glyph)
	skew_input.set_value(font.variation_transform.x.y)

func _set_font_name(value : String) -> void:
	font_name = value

func _on_example_line_edit_changed(text : String) -> void:
	example_label.text = text

func _set_font_size(value) -> void:
	example_label.add_theme_font_size_override('font_size', value)

func _on_embolden_input_changed(value):
	font.variation_embolden = value

func _on_spacing_glyph_input_changed(value):
	font.spacing_glyph = value

func _on_skew_input_changed(value):
	font.variation_transform.x.y = value

func _on_save_button_pressed():
	FontConfigManager.edit_font(font_name, style_name, font)
	Notification.message(tr('KEY_FONT_SAVED_SUCCESSFULLY'))
	FontConfigManager.save_configuration()
