class_name Comic
extends PanelContainer

@onready var default_font_input : LineEdit = $VBoxContainer/HBoxContainer2/DefaultFont

var index : int
var key : String : set = _set_key
var default_font : String : set = _set_default_font
var font_size : float : set = _set_font_size
var comic_type : Preferences.ComicType : set = _set_comic_type
var can_be_deleted : bool : set = _set_can_be_deleted

func _ready() -> void:
	for type in Preferences.comic_type_string:
		$VBoxContainer/HBoxContainer4/ComicType.add_item(type)
	
	FontConfigManager.fonts_changed.connect(_on_fonts_changed)
	_on_fonts_changed()

func _set_key(value : String) -> void:
	key = value
	$VBoxContainer/HBoxContainer5/Name.text = key
	$VBoxContainer/HBoxContainer5/Name.caret_column = key.length()

func _set_default_font(value : String) -> void:
	default_font = value
	default_font_input.text = default_font

func _set_font_size(value : float) -> void:
	font_size = value
	$VBoxContainer/HBoxContainer3/FontSize.value = font_size

func _set_comic_type(value : Preferences.ComicType) -> void:
	comic_type = value
	$VBoxContainer/HBoxContainer4/ComicType.selected = comic_type

func _set_can_be_deleted(value : bool) -> void:
	can_be_deleted = value
	
	if not can_be_deleted:
		$VBoxContainer/HBoxContainer/Delete.hide()
		$VBoxContainer/HBoxContainer5/Name.editable = false

func _on_name_text_changed(new_text: String) -> void:
	key = new_text
	
	Preferences.comics[index].name = key
	Preferences.save_configuration()

func _on_font_size_value_changed(value: float) -> void:
	font_size = value
	
	Preferences.comics[index].font_size = font_size
	Preferences.save_configuration()

func _on_comic_type_item_selected(_index : int) -> void:
	comic_type = _index as Preferences.ComicType
	
	Preferences.comics[index].comic_type = comic_type
	Preferences.save_configuration()

func _on_delete_pressed() -> void:
	Preferences.comics.remove_at(index)
	Preferences.save_configuration()
	queue_free()

func _on_fonts_changed() -> void:
	default_font_input.suggestions_dict = FontConfigManager.fonts

func _on_default_font_value_changed(new_text: String) -> void:
	default_font = new_text
	
	Preferences.comics[index].default_font = default_font
	Preferences.save_configuration()
