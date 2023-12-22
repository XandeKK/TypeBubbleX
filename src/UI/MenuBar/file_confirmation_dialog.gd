extends ConfirmationDialog

@onready var raw_file_dialog : FileDialog = $RawFileDialog
@onready var cleaned_file_dialog : FileDialog = $CleanedFileDialog
@onready var texts_file_dialog : FileDialog = $TextsFileDialog

@onready var raw : LineEdit = $VBoxContainer/HBoxContainer/RawLineEdit
@onready var cleaned : LineEdit = $VBoxContainer/HBoxContainer2/CleanedLineEdit
@onready var texts : LineEdit = $VBoxContainer/HBoxContainer3/TextsLineEdit
@onready var styles : OptionButton = $VBoxContainer/HBoxContainer4/StylesOptionButton
@onready var ia : CheckBox = $VBoxContainer/HBoxContainer5/IACheckBox

func _ready():
	for key in Preference.styles_string.keys():
		styles.add_item(Preference.styles_string[key], key)

func _on_confirmed():
	cleaned.text = cleaned.text.strip_edges()
	raw.text = raw.text.strip_edges()
	texts.text = texts.text.strip_edges()
	
	var dir_acess = DirAccess.open('')
	
	if cleaned.text.is_empty():
		print('cleaned is empty')
		return
	if not dir_acess.dir_exists(cleaned.text):
		print("cleaned don't exist")
		return
		
	if not dir_acess.dir_exists(raw.text):
		print("raw don't exist")
		return
	
	FileHandler.open({
		'cleaned': cleaned.text,
		'raw': null if raw.text.is_empty() else raw.text,
		'texts': null if texts.text.is_empty() else texts.text,
		'style': styles.selected,
		'ia': ia.button_pressed,
	})
	hide()

func _on_raw_button_pressed():
	raw_file_dialog.show()

func _on_cleaned_button_pressed():
	cleaned_file_dialog.show()

func _on_texts_button_pressed():
	texts_file_dialog.show()

func _on_raw_file_dialog_dir_selected(dir):
	raw.text = dir

func _on_cleaned_file_dialog_dir_selected(dir):
	cleaned.text = dir

func _on_texts_file_dialog_file_selected(path):
	texts.text = path

func _on_styles_option_button_item_selected(index):
	pass # Replace with function body.
