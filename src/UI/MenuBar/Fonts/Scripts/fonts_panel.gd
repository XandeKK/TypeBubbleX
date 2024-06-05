extends PanelContainer

@export var max_items : int = 12

@onready var font_name : LineEdit = $ScrollContainer/MarginContainer/VBoxContainer/FontNameLineEdit
@onready var example_line_edit : LineEdit = $ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer2/ExampleLineEdit
@onready var font_size_input : _Input = $ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer2/FontSizeInput
@onready var scroll_container : ScrollContainer = $ScrollContainer/MarginContainer/VBoxContainer/PanelContainer/ScrollContainer
@onready var grid_container : GridContainer = $ScrollContainer/MarginContainer/VBoxContainer/PanelContainer/ScrollContainer/MarginContainer/GridContainer
@onready var page_line_edit : LineEdit = $ScrollContainer/MarginContainer/VBoxContainer/PagesHBoxContainer/PageLineEdit
@onready var max_page_label : Label = $ScrollContainer/MarginContainer/VBoxContainer/PagesHBoxContainer/MaxPageLabel
@onready var font_item : PackedScene = load('res://src/UI/MenuBar/Fonts/FontsPanel/font_item.tscn')

var show_fonts : bool = false
var selected_fonts : bool = false
var current_page : int  = 0

var fonts : Array
var filtered_fonts : Array

func _ready():
	font_size_input.set_value(25)
	FontConfigManager.directories_changed.connect(_on_directories_changed)
	_on_directories_changed()

func restock() -> void:
	clear()
	
	var start_index : int = current_page * max_items
	var end_index : int = min((current_page + 1) * max_items, filtered_fonts.size())
	
	for i in range(start_index, end_index):
		var font_item_dup = font_item.instantiate()
		grid_container.add_child(font_item_dup)
		font_item_dup.font_name = filtered_fonts[i]
		font_item_dup.selected = FontConfigManager.fonts.has(filtered_fonts[i])
		font_item_dup.show_fonts = show_fonts
		font_item_dup.example.text = example_line_edit.text
		font_item_dup.example.add_theme_font_size_override('font_size', int(font_size_input.get_value()))
		example_line_edit.text_changed.connect(font_item_dup.on_text_changed)
		font_size_input.changed.connect(font_item_dup.on_font_size_changed)
	
	update_pages_label()
	scroll_container.scroll_vertical = 0

func update_pages_label() -> void:
	var total_pages : int = ceil(filtered_fonts.size() / float(max_items))
	page_line_edit.text = str(current_page + 1)
	max_page_label.text = "/" + str(total_pages)

func clear() -> void:
	for child in grid_container.get_children():
		child.queue_free()

func filter_fonts() -> void:
	filtered_fonts.clear()
	
	var text : String = font_name.text.to_lower()
	
	for font in fonts:
		var font_lower : String = font.to_lower()
		
		if not text.is_empty():
			if not font_lower.contains(text):
				continue
		
		if selected_fonts and not FontConfigManager.fonts.has(font):
			continue
		filtered_fonts.append(font)

func _on_font_name_line_edit_text_changed(_new_text):
	filter_fonts()
	current_page = 0
	restock()

func _on_only_selected_check_box_toggled(toggled_on):
	selected_fonts = toggled_on
	filter_fonts()
	current_page = 0
	restock()

func _on_show_fonts_check_box_toggled(toggled_on):
	show_fonts = toggled_on
	restock()

func _on_page_line_edit_text_submitted(text : String):
	var total_pages : int = ceil(filtered_fonts.size() / float(max_items))
	
	if int(text) < 0:
		current_page = 0
	elif int(text) >= total_pages - 1:
		current_page = total_pages - 1
	else:
		current_page = int(text) - 1

	restock()

func _on_back_button_pressed():
	if current_page > 0:
		current_page -= 1
		restock()

func _on_foward_button_pressed():
	var total_pages : int = ceil(filtered_fonts.size() / float(max_items))
	if current_page < total_pages - 1:
		current_page += 1
		restock()

func _on_directories_changed() -> void:
	fonts = FontConfigManager.fonts_path.keys()
	filter_fonts()
	current_page = 0
	restock()
