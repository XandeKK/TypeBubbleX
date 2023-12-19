extends ConfirmationDialog

@onready var raw_dialog : NativeFileDialog = $RawNativeFolderDialog
@onready var cleaned_dialog : NativeFileDialog = $CleanedNativeFolderDialog
@onready var texts_dialog : NativeFileDialog = $TextsNativeFileDialog

@onready var raw : LineEdit = $VBoxContainer/HBoxContainer/RawLineEdit
@onready var cleaned : LineEdit = $VBoxContainer/HBoxContainer2/CleanedLineEdit
@onready var texts : LineEdit = $VBoxContainer/HBoxContainer3/TextsLineEdit
@onready var styles : OptionButton = $VBoxContainer/HBoxContainer4/StylesOptionButton
@onready var ia : CheckBox = $VBoxContainer/HBoxContainer5/IACheckBox

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
		'style': styles.get_item_text(styles.get_selected_id()),
		'ia': ia.button_pressed,
	})
	hide()

func _on_raw_button_pressed():
	raw_dialog.show()

func _on_cleaned_button_pressed():
	cleaned_dialog.show()

func _on_texts_button_pressed():
	texts_dialog.show()

func _on_raw_native_folder_dialog_dir_selected(dir):
	raw.text = dir
	raw_dialog.root_subfolder = dir
	cleaned_dialog.root_subfolder = dir
	texts_dialog.root_subfolder = dir

func _on_cleaned_native_folder_dialog_dir_selected(dir):
	cleaned.text = dir
	raw_dialog.root_subfolder = dir
	cleaned_dialog.root_subfolder = dir
	texts_dialog.root_subfolder = dir

func _on_texts_native_file_dialog_file_selected(path):
	texts.text = path
