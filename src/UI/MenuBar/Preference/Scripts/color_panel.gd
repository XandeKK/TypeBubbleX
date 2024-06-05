extends PanelContainer

@onready var bubble_active : _InputColor = $ScrollContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/BubbleActiveInputColor
@onready var bubble_inactive : _InputColor = $ScrollContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/BubbleInactiveInputColor
@onready var padding_active : _InputColor = $ScrollContainer/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/PaddingActiveInputColor

var color_picker : ColorPicker

func _ready():
	bubble_active.default_color = Preference.default_colors.bubble.active
	bubble_inactive.default_color = Preference.default_colors.bubble.inactive
	padding_active.default_color = Preference.default_colors.padding.active

	bubble_active.set_color(Preference.colors.bubble.active)
	bubble_inactive.set_color(Preference.colors.bubble.inactive)
	padding_active.set_color(Preference.colors.padding.active)

func _on_bubble_active_input_color_changed(value):
	Preference.colors.bubble.active = value
	Preference.save_configuration()

func _on_bubble_inactive_input_color_changed(value):
	Preference.colors.bubble.inactive = value
	Preference.save_configuration()

func _on_padding_active_input_color_changed(value):
	Preference.colors.padding.active = value
	Preference.save_configuration()


func _on_color_picker_button_picker_created():
	color_picker = $ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/ColorPickerButton.get_picker()
	color_picker.connect('preset_added', _on_preset_added)
	color_picker.connect('preset_removed', _on_preset_removed)
	
	for swatch in Preference.colors.swatches.keys():
		color_picker.add_preset(swatch)

func _on_preset_added(color : Color):
	Preference.colors.swatches[color] = null
	Preference.save_configuration()

func _on_preset_removed(color : Color):
	Preference.colors.swatches.erase(color)
	Preference.save_configuration()
