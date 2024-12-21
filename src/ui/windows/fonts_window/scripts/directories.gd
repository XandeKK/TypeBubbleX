extends PanelContainer

@onready var path_box : PathBox = $VBoxContainer/HBoxContainer/PathBox
@onready var item_list : ItemList = $VBoxContainer/ItemList

var directory_selected : int = -1

func _ready() -> void:
	for directory : String in FontConfigManager.directories:
		item_list.add_item(directory)
	
	FontConfigManager.directories_changed.connect(restock)

func restock() -> void:
	item_list.clear()
	
	for directory : String in FontConfigManager.directories:
		item_list.add_item(directory)

func _on_add_button_pressed() -> void:
	if path_box.valid_path:
		FontConfigManager.add_directory(path_box.get_text())
	
	path_box.line_edit.clear()

func _on_remove_button_pressed() -> void:
	if not item_list.is_anything_selected() or directory_selected == -1:
		return
	
	item_list.remove_item(directory_selected)
	FontConfigManager.remove_directory(directory_selected)
	
	directory_selected = -1

func _on_item_list_item_selected(index: int) -> void:
	directory_selected = index
