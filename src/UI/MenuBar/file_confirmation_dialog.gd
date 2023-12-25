extends ConfirmationDialog

@onready var path_file_dialog : FileDialog = $PathFileDialog

@onready var path : LineEdit = $PanelContainer/VBoxContainer/HBoxContainer/HBoxContainer/PathLineEdit
@onready var styles : OptionButton = $PanelContainer/VBoxContainer/HBoxContainer2/StylesOptionButton
@onready var ia : CheckBox = $PanelContainer/VBoxContainer/HBoxContainer3/IACheckBox

func _ready():
	for key in Preference.styles_string.keys():
		styles.add_item(Preference.styles_string[key], key)

func _on_confirmed():
	path.text = path.text.strip_edges()
	
	var dir_acess = DirAccess.open('')
	
	if path.text.is_empty():
		print('path is empty')
		return
	
	if not dir_acess.dir_exists(path.text):
		print("path don't exist")
		return
		
	FileHandler.open({
		'path': path.text,
		'style': styles.selected,
		'ia': ia.button_pressed,
	})
	hide()

func _on_path_button_pressed():
	path_file_dialog.show()

func _on_path_file_dialog_dir_selected(dir):
	path.text = dir
