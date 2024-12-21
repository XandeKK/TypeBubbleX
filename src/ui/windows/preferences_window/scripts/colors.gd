extends PanelContainer

func _ready() -> void:
	$VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/BubbleActive.color = Preferences.colors['bubble']['active']
	$VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/BubbleInactive.color = Preferences.colors['bubble']['inactive']
	
	$VBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer/PaddingActive.color = Preferences.colors['padding']['active']

	$VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/BubbleActive.color_changed.connect(update_preferences.bind('bubble/active'))
	$VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/BubbleInactive.color_changed.connect(update_preferences.bind('bubble/inactive'))
	
	$VBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer/PaddingActive.color_changed.connect(update_preferences.bind('padding/active'))

func update_preferences(value : Variant, key : String):
	if key.contains('/'):
		var keys : Array = key.split('/')
		Preferences.colors[keys[0]][keys[1]] = value
	else:
		Preferences.colors[key] = value

	Preferences.save_configuration()

func _on_swatches_picker_created() -> void:
	var color_picker : ColorPicker = $VBoxContainer/HBoxContainer/Swatches.get_picker()
	color_picker.preset_added.connect(_on_preset_added)
	color_picker.preset_removed.connect(_on_preset_removed)
	
	for swatch in Preferences.colors.swatches.keys():
		color_picker.add_preset(swatch)

func _on_preset_added(color : Color) -> void:
	Preferences.colors.swatches[color] = null
	Preferences.save_configuration()

func _on_preset_removed(color : Color) -> void:
	Preferences.colors.swatches.erase(color)
	Preferences.save_configuration()
