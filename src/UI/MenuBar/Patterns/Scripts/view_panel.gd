extends PanelContainer

@onready var line_edit : LineEdit = $MarginContainer/VBoxContainer/LineEdit
@onready var grid_container : GridContainer = $MarginContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var scroll_container : ScrollContainer = $MarginContainer/VBoxContainer/ScrollContainer
@onready var page_line_edit : LineEdit = $MarginContainer/VBoxContainer/PagesHBoxContainer/PageLineEdit
@onready var max_page_label : Label = $MarginContainer/VBoxContainer/PagesHBoxContainer/MaxPageLabel

var current_page : int  = 0

var max_items : int = 15
var images : Array
var filtered_images : Array

func _ready():
	PatternsManager.directories_changed.connect(_on_directories_changed)
	_on_directories_changed()

func restock() -> void:
	clear()
	
	var start_index : int = current_page * max_items
	var end_index : int = min((current_page + 1) * max_items, filtered_images.size())
	
	for i in range(start_index, end_index):
		var image : TextureRect = TextureRect.new()
		grid_container.add_child(image)
		var texture = FileHandler.load_image(filtered_images[i])
		image.texture = texture
		image.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		image.expand_mode = TextureRect.EXPAND_FIT_HEIGHT
	
	update_pages_label()
	scroll_container.scroll_vertical = 0

func update_pages_label() -> void:
	var total_pages : int = ceil(filtered_images.size() / float(max_items))
	page_line_edit.text = str(current_page + 1)
	max_page_label.text = "/" + str(total_pages)

func clear() -> void:
	for child in grid_container.get_children():
		child.queue_free()

func filter_images() -> void:
	filtered_images.clear()
	
	var text : String = line_edit.text.to_lower()
	
	for image in images:
		var image_lower : String = image.get_file().to_lower()
		
		if not text.is_empty():
			if not image_lower.contains(text):
				continue
		
		if not PatternsManager.images.has(image):
			continue
		filtered_images.append(image)

func _on_line_edit_text_changed(_new_text):
	filter_images()
	current_page = 0
	restock()

func _on_back_button_pressed():
	if current_page > 0:
		current_page -= 1
		restock()

func _on_page_line_edit_text_submitted(new_text : String):
	var total_pages : int = ceil(filtered_images.size() / float(max_items))
	
	if int(new_text) < 0:
		current_page = 0
	elif int(new_text) >= total_pages - 1:
		current_page = total_pages - 1
	else:
		current_page = int(new_text) - 1

	restock()

func _on_foward_button_pressed():
	var total_pages : int = ceil(filtered_images.size() / float(max_items))
	if current_page < total_pages - 1:
		current_page += 1
		restock()

func _on_directories_changed() -> void:
	images = PatternsManager.images.keys()
	filter_images()
	current_page = 0
	restock()
