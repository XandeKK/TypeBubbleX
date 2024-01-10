extends PanelContainer

func _ready():
	$VBoxContainer/HBoxContainer/FontSizeInput.text = str(Preference.general.font_size)
	$VBoxContainer/HBoxContainer2/LanguageOptionButton.select(Preference.language_to_index(Preference.general.language))

func _on_font_size_input_changed(value):
	Preference.general.font_size = value
	Preference.load_general()
	Preference.save_configuration()

func _on_option_button_item_selected(index):
	var language : String = Preference.index_to_language(index)
	Preference.general.language = language
	Preference.load_general()
	Preference.save_configuration()
