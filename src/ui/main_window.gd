extends Control

@onready var initial_setup_window : Window = $InitialSetup
@onready var error_dialog : AcceptDialog = $ErrorDialog

func _ready() -> void:
	initial_setup()

func initial_setup() -> void:
	if Preference.data.workspace_dir.is_empty():
		initial_setup_window.setup_completed.connect(_initialize)
		initial_setup_window.show()
		error_dialog.queue_free()
		return
	
	var db_path = Preference.data.workspace_dir.path_join("typebubblex.db")
	
	if DirAccess.dir_exists_absolute(Preference.data.workspace_dir) and FileAccess.file_exists(db_path):
		DBClient.open_db(db_path)
		_initialize()
		initial_setup_window.queue_free()
		error_dialog.queue_free()
	else:
		error_dialog.title = "Workspace Error"
		error_dialog.dialog_text = "The previously saved workspace directory or database file could not be found.\n\nPlease select or create a valid workspace to continue."
		error_dialog.popup_centered()

func _initialize() -> void:
	# To do
	pass

func _on_error_dialog_confirmed() -> void:
	initial_setup_window.setup_completed.connect(_initialize)
	initial_setup_window.show()
	
	error_dialog.queue_free()
