@tool
extends HBoxContainer
class_name _InputColor

@export var name_label : String : set = set_name_label
@export var reset : bool = true : set = set_reset

@export_range(0.1, 2) var stretch_ratio_label = 1.0 : set = set_stretch_ratio_label

@onready var label : Label = $Label
@onready var color_picker : ColorPickerButton = $ColorPickerButton
@onready var reset_butotn : Button = $Control/ResetButton

var default_color : Variant
var disabled : bool = false : set = set_disabled

signal changed(value)

func set_color(_value : Color) -> void:
	color_picker.color = _value
	
	if default_color != _value:
		reset_butotn.show()
	else:
		reset_butotn.hide()

func set_name_label(_value : String) -> void:
	_value = _value.strip_escapes()
	if _value.is_empty():
		$Label.hide()
	else:
		$Label.show()
	
	name_label = _value
	$Label.text = _value

func set_stretch_ratio_label(_value : float) -> void:
	$Label.size_flags_stretch_ratio = _value
	stretch_ratio_label = _value

func set_reset(_value : bool) -> void:
	$Control.visible = _value
	reset = _value

func emit():
	emit_signal('changed', color_picker.color)

func _on_reset_button_pressed():
	reset_butotn.hide()
	color_picker.color = default_color
	emit()

func _on_color_picker_button_color_changed(color):
	set_color(color)
	emit()

func set_disabled(value : bool) -> void:
	disabled = value
	color_picker.disabled = value

func add_swatches(colors : Array) -> void:
	var picker = color_picker.get_picker()
	for color : Color in colors:
		picker.add_preset(color)
