extends PanelContainer

func _ready():
	$VBoxContainer/HBoxContainer/FontSizeInput.text = str(Preference.general.font_size)

func _on_font_size_input_changed(value):
	Preference.general.font_size = value
	Preference.load_general()
	Preference.save_configuration()
