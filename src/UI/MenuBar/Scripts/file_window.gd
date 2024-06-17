extends ConfirmationDialog

@onready var file_dialog : FileDialog = $FileDialog

@onready var path : LineEdit = $PanelContainer/MarginContainer/VBoxContainer/PathHBox/PathLineEdit
@onready var hq_types : OptionButton = $PanelContainer/MarginContainer/VBoxContainer/TypesHBox/TypesOption
@onready var ai : CheckButton = $PanelContainer/MarginContainer/VBoxContainer/AIHBox/VBoxContainer/AICheckButton

func _ready():
	for key in Preference.hq_types_string.keys():
		hq_types.add_item(Preference.hq_types_string[key], key)

func _on_confirmed():
	path.text = path.text.strip_edges()
	
	var dir_acess = DirAccess.open('.')
	
	if path.text.is_empty():
		Notification.message(tr('KEY_PATH_IS_EMPTY'))
		return
	
	if not dir_acess.dir_exists(path.text):
		Notification.message(tr('KEY_PATH_DONT_EXIST'))
		return
	
	FileHandler.open({
		'path': path.text,
		'type': hq_types.selected,
		'AI': ai.button_pressed,
	})
	hide()
	queue_free()

func _on_file_dialog_dir_selected(dir):
	path.text = dir

func _on_path_button_pressed():
	file_dialog.show()

func _on_canceled():
	hide()
	queue_free()
