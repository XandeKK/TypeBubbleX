extends PanelContainer

@onready var manga_input_drop_down : LineEdit = $ScrollContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/MangaInputDropDown
@onready var manhwa_input_drop_down : LineEdit = $ScrollContainer/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer/ManhwaInputDropDown

@onready var manga_font_size : _Input = $ScrollContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/MangaFontSizeInput
@onready var manhwa_font_size : _Input = $ScrollContainer/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/ManhwaFontSizeInput

var manga = Preference.HQTypes.MANGA
var manhwa = Preference.HQTypes.MANHWA

func _ready():
	manga_input_drop_down.text = Preference.hq_types[manga].default_font if Preference.hq_types[manga].default_font else ''
	manga_input_drop_down.callable_search = search_font
	manga_input_drop_down.list = FontConfigManager.fonts
	manga_input_drop_down.key = 'font'
	
	manhwa_input_drop_down.text = Preference.hq_types[manhwa].default_font if Preference.hq_types[manhwa].default_font else ''
	manhwa_input_drop_down.callable_search = search_font
	manhwa_input_drop_down.list = FontConfigManager.fonts
	manhwa_input_drop_down.key = 'font'
	
	manga_font_size.set_value(Preference.hq_types[manga].font_size)
	manhwa_font_size.set_value(Preference.hq_types[manhwa].font_size)

func search_font(font : Dictionary, new_text : String):
	return font['font'].to_lower().contains(new_text) or \
		font['nickname'] != null and font['nickname'].to_lower().contains(new_text)

func check_font() -> void:
	if FontConfigManager.fonts.has(manga_input_drop_down.text):
		return
	else:
		manga_input_drop_down.text = ''
	
	if FontConfigManager.fonts.has(manhwa_input_drop_down.text):
		return
	else:
		manhwa_input_drop_down.text = ''

func _on_manga_input_drop_down_changed(value):
	Preference.hq_types[manga].default_font = value
	Preference.save_configuration()

func _on_manhwa_input_drop_down_changed(value):
	Preference.hq_types[manhwa].default_font = value
	Preference.save_configuration()

func _on_manga_font_size_input_changed(value):
	Preference.hq_types[manga].font_size = value
	Preference.save_configuration()

func _on_manhwa_font_size_input_changed(value):
	Preference.hq_types[manhwa].font_size = value
	Preference.save_configuration()
