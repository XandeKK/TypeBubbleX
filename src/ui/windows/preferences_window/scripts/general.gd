extends PanelContainer

func _ready() -> void:
	for language: String in Preferences.languages:
		$VBoxContainer/HBoxContainer/Language.add_item(language)
	
	$VBoxContainer/HBoxContainer/Language.select(Preferences.general['language'])
	$VBoxContainer/HBoxContainer2/FontSize.value = Preferences.general['font_size']
	$VBoxContainer/HBoxContainer3/RawDir.text = Preferences.general['raw_dir']
	$VBoxContainer/HBoxContainer4/CleanedDir.text = Preferences.general['cleaned_dir']
	$VBoxContainer/HBoxContainer5/TypeBubbleXDir.text = Preferences.general['type_bubble_x_dir']
	$VBoxContainer/HBoxContainer6/TextFilename.text = Preferences.general['text_filename']
	$VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/MinZoom.value = Preferences.general['camera']['min_zoom']
	$VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer3/MaxZoom.value = Preferences.general['camera']['max_zoom']
	$VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer4/ZoomRate.value = Preferences.general['camera']['zoom_rate']
	
	$VBoxContainer/HBoxContainer/Language.item_selected.connect(update_preferences.bind('language'))
	$VBoxContainer/HBoxContainer2/FontSize.value_changed.connect(update_preferences.bind('font_size'))
	$VBoxContainer/HBoxContainer3/RawDir.text_changed.connect(update_preferences.bind('raw_dir'))
	$VBoxContainer/HBoxContainer4/CleanedDir.text_changed.connect(update_preferences.bind('cleaned_dir'))
	$VBoxContainer/HBoxContainer5/TypeBubbleXDir.text_changed.connect(update_preferences.bind('type_bubble_x_dir'))
	$VBoxContainer/HBoxContainer6/TextFilename.text_changed.connect(update_preferences.bind('text_filename'))
	$VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/MinZoom.value_changed.connect(update_preferences.bind('camera/min_zoom'))
	$VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer3/MaxZoom.value_changed.connect(update_preferences.bind('camera/max_zoom'))
	$VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer4/ZoomRate.value_changed.connect(update_preferences.bind('camera/zoom_rate'))

func update_preferences(value : Variant, key : String):
	if key.contains('/'):
		var keys : Array = key.split('/')
		Preferences.general[keys[0]][keys[1]] = value
	else:
		Preferences.general[key] = value

	Preferences.save_configuration()
