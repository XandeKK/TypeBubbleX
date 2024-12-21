class_name Gradient1DEditor
extends Control

@onready var g_1d_editor : G1DEditor = $"HBoxContainer/1DEditor"
@onready var color_picker_button : ColorPickerButton = $HBoxContainer/ColorPickerButton

var editable : bool = true : set = _set_editable

func set_gradient(gradient : Gradient) -> void:
	g_1d_editor.gradient = gradient

func clear() -> void:
	g_1d_editor.clear()
	color_picker_button.color = Color.BLACK

func _set_editable(value : bool) -> void:
	editable = value
	visible = value
