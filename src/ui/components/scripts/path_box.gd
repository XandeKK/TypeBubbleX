class_name PathBox
extends HBoxContainer

signal text_changed(text : String)

@onready var line_edit : LineEdit = $LineEdit
@onready var file_dialog : FileDialog = $FileDialog

var valid_path : bool = false

func set_text(new_text : String, line_edit_changed : bool = true) -> void:
	if not line_edit_changed:
		line_edit.text = new_text
		line_edit.caret_column = new_text.length()
	
	valid_path = DirAccess.dir_exists_absolute(new_text) and not new_text.is_empty()
	
	if valid_path:
		pass
	else:
		pass
	
	text_changed.emit(new_text)

func get_text() -> String:
	return line_edit.text

func _on_line_edit_text_changed(new_text: String) -> void:
	set_text(new_text)

func _on_button_pressed() -> void:
	file_dialog.show()

func _on_file_dialog_dir_selected(dir: String) -> void:
	set_text(dir, false)
