extends PanelContainer


@onready var font_name_line_edit : LineEdit = $ScrollContainer/MarginContainer/VBoxContainer/FontNameLineEdit
@onready var grid_container : GridContainer = $ScrollContainer/MarginContainer/VBoxContainer/PanelContainer/ScrollContainer/MarginContainer/GridContainer

@onready var example_line_edit : LineEdit = $ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/ExampleLineEdit
@onready var font_size_input : _Input = $ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/FontSizeInput
@onready var nickname_input : _Input = $ScrollContainer/MarginContainer/VBoxContainer/NicknameInput

@onready var regular_container : StyleContainer = $ScrollContainer/MarginContainer/VBoxContainer/TabContainer/Regular
@onready var bold_container : StyleContainer = $ScrollContainer/MarginContainer/VBoxContainer/TabContainer/Bold
@onready var italic_container : StyleContainer = $ScrollContainer/MarginContainer/VBoxContainer/TabContainer/Italic
@onready var bold_italic_container : StyleContainer = $ScrollContainer/MarginContainer/VBoxContainer/TabContainer/BoldItalic

@onready var font_item : PackedScene = load('res://src/UI/MenuBar/Fonts/FontsPanel/font_item_edit.tscn')

var filtered_fonts : Array
var selected_font : FontItemEdit

func _ready():
	FontConfigManager.fonts_changed.connect(_on_fonts_changed)
	FontConfigManager.directories_changed.connect(_on_fonts_changed)
	_on_fonts_changed()
	
	example_line_edit.text = "Example"
	font_size_input.set_value(50)

func restock() -> void:
	selected_font = null
	nickname_input.set_value('')
	clear()
	
	for font in filtered_fonts:
		var new_font_item = font_item.instantiate()
		grid_container.add_child(new_font_item)
		new_font_item.pressed.connect(_selected)
		new_font_item.label.text = font

func _selected(_font_item) -> void:
	if selected_font == _font_item:
		return
	
	if selected_font:
		selected_font.unselect()
	
	selected_font = _font_item
	
	selected_font.select()
	
	var nickname = FontConfigManager.fonts[selected_font.label.text]['nickname']
	nickname_input.set_value(nickname if nickname else '')
	
	var font_dict : Dictionary = FontConfigManager.fonts[selected_font.label.text]
	set_fonts(font_dict)

func clear() -> void:
	for child in grid_container.get_children():
		child.queue_free()

func filter_fonts() -> void:
	filtered_fonts.clear()
	
	var text : String = font_name_line_edit.text.to_lower()
	
	for font in FontConfigManager.fonts.keys():
		var font_lower : String = font.to_lower()
		
		if not text.is_empty():
			if not font_lower.contains(text):
				continue
		filtered_fonts.append(font)
#
func set_fonts(font_dict : Dictionary) -> void:
	regular_container.font = font_dict['regular'].duplicate()
	bold_container.font = font_dict['bold'].duplicate()
	italic_container.font = font_dict['italic'].duplicate()
	bold_italic_container.font = font_dict['bold-italic'].duplicate()
	
	regular_container.font_name = font_dict['font']
	bold_container.font_name = font_dict['font']
	italic_container.font_name = font_dict['font']
	bold_italic_container.font_name = font_dict['font']
#
func _on_font_name_line_edit_text_changed(_new_text):
	filter_fonts()
	restock()
#
func _on_example_line_edit_text_changed(new_text):
	regular_container.example_label.text = new_text
	bold_container.example_label.text = new_text
	italic_container.example_label.text = new_text
	bold_italic_container.example_label.text = new_text

func _on_fonts_changed() -> void:
	filter_fonts()
	restock()

func _on_font_size_input_changed(value):
	regular_container.font_size = value
	bold_container.font_size = value
	italic_container.font_size = value
	bold_italic_container.font_size = value

func _on_nickname_input_changed(text):
	if not selected_font:
		return
	
	FontConfigManager.edit_nickname(selected_font.label.text, text)
	FontConfigManager.save_configuration()
