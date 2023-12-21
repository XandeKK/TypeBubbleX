extends PanelContainer

@onready var font_name_line_edit : LineEdit = $VBoxContainer/HBoxContainer/FontNameLineEdit
@onready var font_list : ItemList = $VBoxContainer/FontList
@onready var styles_panel_container : PanelContainer = $VBoxContainer/StylesPanelContainer

@onready var nickname_line_edit : LineEdit = $VBoxContainer/HBoxContainer2/NicknameLineEdit

@onready var regular_body : VBoxContainer = $VBoxContainer/StylesPanelContainer/ScrollContainer/MarginContainer/VBoxContainer/RegularBoxContainer
@onready var bold_body : VBoxContainer = $VBoxContainer/StylesPanelContainer/ScrollContainer/MarginContainer/VBoxContainer/BoldBoxContainer
@onready var italic_body : VBoxContainer = $VBoxContainer/StylesPanelContainer/ScrollContainer/MarginContainer/VBoxContainer/ItalicBoxContainer
@onready var bold_italic_body : VBoxContainer = $VBoxContainer/StylesPanelContainer/ScrollContainer/MarginContainer/VBoxContainer/BoldItalicBoxContainer

var filtered_fonts : Array
var selected_font : String

func _ready():
	FontConfigManager.fonts_changed.connect(_on_fonts_changed)
	FontConfigManager.dirs_changed.connect(_on_fonts_changed)
	_on_fonts_changed()

func restock() -> void:
	selected_font = ''
	nickname_line_edit.text = ''
	styles_panel_container.hide()
	font_list.clear()
	
	for font in filtered_fonts:
		font_list.add_item(font)

func filter_fonts() -> void:
	filtered_fonts.clear()
	
	var text : String = font_name_line_edit.text.to_lower()
	
	for font in FontConfigManager.fonts.keys():
		var font_lower : String = font.to_lower()
		
		if not text.is_empty():
			if not font_lower.contains(text):
				continue
		filtered_fonts.append(font)

func set_fonts(font_dict : Dictionary) -> void:
	regular_body.font = font_dict['regular'].duplicate()
	bold_body.font = font_dict['bold'].duplicate()
	italic_body.font = font_dict['italic'].duplicate()
	bold_italic_body.font = font_dict['bold-italic'].duplicate()
	
	regular_body.font_name = font_dict['font']
	bold_body.font_name = font_dict['font']
	italic_body.font_name = font_dict['font']
	bold_italic_body.font_name = font_dict['font']

func _on_font_name_line_edit_text_changed(new_text):
	filter_fonts()
	restock()

func _on_example_line_edit_text_changed(new_text):
	regular_body.example_label.text = new_text
	bold_body.example_label.text = new_text
	italic_body.example_label.text = new_text
	bold_italic_body.example_label.text = new_text

func _on_font_list_item_selected(index):
	selected_font = font_list.get_item_text(index)
	styles_panel_container.show()
	
	var nickname = FontConfigManager.fonts[selected_font]['nickname']
	nickname_line_edit.text = nickname if nickname else ''
	
	var font_dict : Dictionary = FontConfigManager.fonts[selected_font]
	set_fonts(font_dict)

func _on_nickname_line_edit_text_changed(new_text):
	if selected_font.is_empty():
		return
	
	FontConfigManager.edit_nickname(selected_font, new_text)
	FontConfigManager.save_configuration()

func _on_example_font_size_input_changed(value):
	regular_body.font_size = value
	bold_body.font_size = value
	italic_body.font_size = value
	bold_italic_body.font_size = value

func _on_fonts_changed() -> void:
	filter_fonts()
	restock()
