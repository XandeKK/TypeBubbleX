extends PanelContainer

@onready var file_dialog : FileDialog = $FileDialog

@onready var directory_line_edit : LineEdit = $ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/DirectoryLineEdit
@onready var item_list : ItemList = $ScrollContainer/MarginContainer/VBoxContainer/ItemList

var selected_item : int = -1

func _ready():
	FontConfigManager.directories_changed.connect(_on_directories_changed)
	_on_directories_changed()

func _on_directories_changed() -> void:
	selected_item = 0
	item_list.clear()
	for dir in FontConfigManager.directories:
		item_list.add_item(dir)

func _on_file_dialog_button_pressed():
	file_dialog.show()

func _on_add_button_pressed():
	if directory_line_edit.text.is_empty():
		return
	FontConfigManager.add_directory(directory_line_edit.text)
	directory_line_edit.text = ''
	FontConfigManager.save_configuration()

func _on_remove_button_pressed():
	if selected_item != -1:
		FontConfigManager.remove_directory(selected_item)
		selected_item = -1
	FontConfigManager.save_configuration()

func _on_item_list_item_selected(index):
	selected_item = index

func _on_file_dialog_dir_selected(dir):
	directory_line_edit.text = dir
