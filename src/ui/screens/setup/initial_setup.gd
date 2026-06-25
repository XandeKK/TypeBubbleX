extends Window

signal setup_completed

@onready var path_line_edit : LineEdit = $PanelContainer/VBoxContainer/PathHBox/PathLineEdit
@onready var message_label : Label = $PanelContainer/VBoxContainer/MessageLabel
@onready var create_folder_check_button : CheckButton = $PanelContainer/VBoxContainer/HBoxContainer/CreateFolderCheckButton
@onready var file_dialog : FileDialog = $FileDialog
@onready var action_button : Button = $PanelContainer/VBoxContainer/ActionHBox/ActionButton

const DEFAULT_DATABASE_FILE_NAME : String = "typebubblex.db"
const DEFAULT_DIR_NAME : String = "TypeBubbleX"

const MSG_WARNING_NOT_EMPTY = "The selected path is not empty. Choosing an empty folder is highly recommended."
const MSG_ERROR_PATH_NOT_FOUND = "The path specified doesn't exist."
const MSG_INFO_AUTO_CREATE_FOLDER = "The project folder will be automatically created."
const MSG_INFO_PATH_EMPTY = "The project folder exists and is empty."
const MSG_INFO_LOAD_EXISTING = "A valid project file was found. The project will be loaded from this directory."

enum Status { ERROR_PATH_NOT_FOUND, WARNING_NOT_EMPTY, INFO_AUTO_CREATE_FOLDER, INFO_PATH_EMPTY, INFO_LOAD_EXISTING }

var current_path : String = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS).path_join(DEFAULT_DIR_NAME)
var current_status : Status = Status.INFO_AUTO_CREATE_FOLDER
var should_create_folder : bool = true

func _ready() -> void:
	path_line_edit.text = current_path
	create_folder_check_button.set_pressed_no_signal(should_create_folder)
	_validate_and_update_path(current_path)

func _validate_and_update_path(target_path : String) -> void:
	current_path = target_path
	
	if _is_valid_path(target_path):
		if _has_files_in_folder(target_path):
			if _has_database_project_file(target_path):
				_update_status(Status.INFO_LOAD_EXISTING)
			else:
				_update_status(Status.WARNING_NOT_EMPTY)
		else:
			if should_create_folder:
				_update_status(Status.INFO_AUTO_CREATE_FOLDER)
			else:
				_update_status(Status.INFO_PATH_EMPTY)
	else:
		if should_create_folder and _is_valid_path(target_path.get_base_dir()):
			_update_status(Status.INFO_AUTO_CREATE_FOLDER)
		else:
			_update_status(Status.ERROR_PATH_NOT_FOUND)

func _update_status(new_status : Status) -> void:
	current_status = new_status
	action_button.disabled = false
	
	match new_status:
		Status.ERROR_PATH_NOT_FOUND:
			message_label.text = MSG_ERROR_PATH_NOT_FOUND
			message_label.self_modulate = Color.RED
			action_button.text = "Create"
			action_button.disabled = true
		Status.WARNING_NOT_EMPTY:
			message_label.text = MSG_WARNING_NOT_EMPTY
			message_label.self_modulate = Color.YELLOW
			action_button.text = "Create"
		Status.INFO_AUTO_CREATE_FOLDER:
			message_label.text = MSG_INFO_AUTO_CREATE_FOLDER
			message_label.self_modulate = Color.GREEN
			action_button.text = "Create"
		Status.INFO_PATH_EMPTY:
			message_label.text = MSG_INFO_PATH_EMPTY
			message_label.self_modulate = Color.GREEN
			action_button.text = "Create"
		Status.INFO_LOAD_EXISTING:
			message_label.text = MSG_INFO_LOAD_EXISTING
			message_label.self_modulate = Color.GREEN
			action_button.text = "Import"

func _is_valid_path(target_path : String) -> bool:
	return DirAccess.dir_exists_absolute(target_path)

func _has_files_in_folder(target_path : String) -> bool:
	var dir : DirAccess = DirAccess.open(target_path)
	
	if dir:
		dir.list_dir_begin()
		var file_name : String = dir.get_next()
		
		if file_name != "":
			dir.list_dir_end()
			return true
		
		dir.list_dir_end()
	
	return false

func _has_database_project_file(target_path : String) -> bool:
	var project_file_path = target_path.path_join(DEFAULT_DATABASE_FILE_NAME)
	return FileAccess.file_exists(project_file_path)

func _on_create_folder_check_button_toggled(toggled_on : bool) -> void:
	var path_text : String = path_line_edit.text.strip_edges()
	should_create_folder = toggled_on
	
	if toggled_on:
		var base_dir = path_text
		if base_dir.get_file() != DEFAULT_DIR_NAME:
			path_text = base_dir.path_join(DEFAULT_DIR_NAME)
	else:
		if path_text.get_file() != "":
			path_text = path_text.get_base_dir()
	
	path_line_edit.text = path_text
	_validate_and_update_path(path_text)

func _on_path_line_edit_text_changed(new_text : String) -> void:
	_validate_and_update_path(new_text)

func _on_file_dialog_button_pressed() -> void:
	file_dialog.popup_centered()

func _on_file_dialog_dir_selected(dir : String) -> void:
	if should_create_folder:
		dir = dir.path_join(DEFAULT_DIR_NAME)
	
	path_line_edit.text = dir
	_validate_and_update_path(dir)

func _on_action_button_pressed() -> void:
	if current_status == Status.ERROR_PATH_NOT_FOUND:
		return
	
	var is_existing_project : bool = current_status == Status.INFO_LOAD_EXISTING
	
	if not is_existing_project:
		if not _is_valid_path(current_path):
			var err : Error = DirAccess.make_dir_absolute(current_path)
			if err != OK:
				_update_status(Status.ERROR_PATH_NOT_FOUND)
				return

	DBClient.open_db(current_path.path_join(DEFAULT_DATABASE_FILE_NAME))
	Preference.data.workspace_dir = current_path
	Preference.save_preferences()
	
	setup_completed.emit()
	
	queue_free()
