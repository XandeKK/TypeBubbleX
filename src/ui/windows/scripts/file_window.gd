extends Window

signal confirmed(data : Dictionary)

@onready var path : PathBox = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PathBox
@onready var raw_path : PathBox = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/RawPathBox
@onready var cleaned_path : PathBox = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/CleanedPathBox
@onready var comic_option : OptionButton = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Comic
@onready var ai : CheckButton = $PanelContainer/MarginContainer/VBoxContainer/AI

func _ready() -> void:
	comic_option.clear()
	
	for comic : Dictionary in Preferences.comics:
		comic_option.add_item(comic.name)

func _on_path_box_text_changed(new_text: String) -> void:
	raw_path.set_text(new_text.path_join(Preferences.general.raw_dir), false)
	cleaned_path.set_text(new_text.path_join(Preferences.general.cleaned_dir), false)

func _on_cancel_pressed() -> void:
	queue_free()

func _on_ok_pressed() -> void:
	if not raw_path.valid_path or not cleaned_path.valid_path:
		# notification
		return
	
	var data : Dictionary = {
		'raw_path': raw_path.get_text(),
		'cleaned_path': cleaned_path.get_text(),
		'comic': comic_option.get_item_text(comic_option.get_selected_id()),
		'ai': ai.button_pressed,
	}
	
	confirmed.emit(data)
	queue_free()
