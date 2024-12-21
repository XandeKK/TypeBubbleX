extends PanelContainer

@export var max_items : int = 12

@onready var font_input : LineEdit = $VBoxContainer/FontName
@onready var scroll_container : ScrollContainer = $VBoxContainer/ScrollContainer
@onready var grid_container : GridContainer = $VBoxContainer/ScrollContainer/GridContainer
@onready var example : LineEdit = $VBoxContainer/HBoxContainer2/Example
@onready var font_size : NumberBox = $VBoxContainer/HBoxContainer2/FontSize
@onready var current_page : NumberBox = $VBoxContainer/HBoxContainer3/CurrentPage
@onready var max_page : Label = $VBoxContainer/HBoxContainer3/MaxPage

var is_selected_fonts_only : bool = false
var is_showing_fonts : bool = false
var available_fonts : Array = []

var font_scene : PackedScene = load('res://src/ui/windows/fonts_window/scenes/font.tscn')

func _ready() -> void:
	FontConfigManager.directories_changed.connect(_on_directories_changed)
	_on_directories_changed()

func restock() -> void:
	clear()
	
	@warning_ignore("narrowing_conversion")
	var start_index : int = current_page.value * max_items
	var end_index : int = min((current_page.value + 1) * max_items, available_fonts.size())
	
	for i : int in range(start_index, end_index):
		var font : PanelContainer = font_scene.instantiate()
		
		grid_container.add_child(font)
		font.font_name = available_fonts[i]
		font.selected = FontConfigManager.fonts.has(available_fonts[i])
		font.show_font = is_showing_fonts
		font.set_example(example.text)
		font.set_font_size(font_size.value)
		
		example.text_changed.connect(font.set_example)
		font_size.value_changed.connect(font.set_font_size)
	
	update_pages()
	scroll_container.scroll_vertical = 0

func update_pages() -> void:
	var total_pages : int = ceil(available_fonts.size() / float(max_items)) - 1
	current_page.max_value = total_pages
	max_page.text = " / " + str(total_pages)

func clear() -> void:
	for child in grid_container.get_children():
		child.queue_free()

func filter_available_fonts() -> void:
	available_fonts.clear()
	
	var search_text : String = font_input.text.to_lower()
	
	for font in FontConfigManager.fonts_path.keys():
		var font_lower : String = font.to_lower()
		
		if not search_text.is_empty() and not font_lower.contains(search_text):
			continue
		
		if is_selected_fonts_only and not FontConfigManager.fonts.has(font):
			continue
		
		available_fonts.append(font)

func _on_font_name_text_changed(_new_text: String) -> void:
	filter_available_fonts()
	current_page.value = 0
	restock()

func _on_only_selected_toggled(toggled_on: bool) -> void:
	is_selected_fonts_only = toggled_on
	filter_available_fonts()
	current_page.value = 0
	restock()

func _on_show_fonts_toggled(toggled_on: bool) -> void:
	is_showing_fonts = toggled_on
	restock()

func _on_directories_changed() -> void:
	filter_available_fonts()
	current_page.value = 0
	restock()

func _on_current_page_value_changed(_value: float) -> void:
	restock()

func _on_back_button_pressed() -> void:
	if current_page.value > 0:
		current_page.value -= 1
		restock()

func _on_foward_button_pressed() -> void:
	var total_pages : int = ceil(available_fonts.size() / float(max_items)) - 1
	if current_page.value < total_pages:
		current_page.value += 1
		restock()
