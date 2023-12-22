extends PanelContainer

@onready var text_edge_active_color : ColorPickerButton = $ScrollContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/TextEdgeActiveColor
@onready var text_edge_deactive_color : ColorPickerButton = $ScrollContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/TextEdgeDeactiveColor
@onready var padding_active_color : ColorPickerButton = $ScrollContainer/VBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer/PaddingActiveColor

func _ready():
	text_edge_active_color.color = Preference.colors.text_edge.active
	text_edge_deactive_color.color = Preference.colors.text_edge.deactive
	padding_active_color.color = Preference.colors.padding.active

func _on_text_edge_active_color_color_changed(color):
	text_edge_active_color.color = color
	Preference.colors.text_edge.active = color
	Preference.save_configuration()

func _on_text_edge_deactive_color_color_changed(color):
	text_edge_deactive_color.color = color
	Preference.colors.text_edge.deactive = color
	Preference.save_configuration()

func _on_padding_active_color_color_changed(color):
	padding_active_color.color = color
	Preference.colors.padding.active = color
	Preference.save_configuration()
