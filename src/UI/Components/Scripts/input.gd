@tool
extends HBoxContainer
class_name _Input

enum Type { STRING, FLOAT, INTEGER }
@export var type : Type = Type.STRING
@export var name_label : String : set = set_name_label
@export var suffix_label : String : set = set_suffix_label
@export var reset : bool = true : set = set_reset

@export_range(0.1, 2) var stretch_ratio_label = 1.0 : set = set_stretch_ratio_label

@export_category("Number")
@export var step : float = 1.0

@onready var label : Label = $Label
@onready var line_edit : LineEdit = $LineEdit
@onready var suffix : Label = $LineEdit/Suffix
@onready var reset_butotn : Button = $Control/ResetButton

var default_value : Variant
var editable : bool = true : set = set_editable

signal changed(value)

func set_value(_value : Variant) -> void:
	line_edit.text = formart_string(str(_value))
	
	if line_edit.text != str(default_value):
		reset_butotn.show()
	else:
		reset_butotn.hide()

func get_value() -> Variant:
	if type == Type.STRING:
		return line_edit.text
	elif type == Type.INTEGER:
		return line_edit.text.to_int()
	else:
		return line_edit.text.to_float()

func set_name_label(_value : String) -> void:
	_value = _value.strip_escapes()
	if _value.is_empty():
		$Label.hide()
	else:
		$Label.show()
	
	name_label = _value
	$Label.text = _value

func set_suffix_label(_value : String) -> void:
	$LineEdit/Suffix.text = _value
	suffix_label = _value

func set_stretch_ratio_label(_value : float) -> void:
	$Label.size_flags_stretch_ratio = _value
	stretch_ratio_label = _value

func set_reset(_value : bool) -> void:
	$Control.visible = _value
	reset = _value

func formart_string(new_text : String):
	var number
	var _text : String
	if new_text.is_empty() or type == Type.STRING:
		_text = new_text
	elif type == Type.INTEGER:
		number = new_text.to_int()
		_text = str(number)
	elif type == Type.FLOAT:
		if new_text.count('.') == 1 and new_text.ends_with('.'):
			number = new_text.to_float()
			_text = str(number) + '.'
		else:
			number = new_text.to_float()
			_text = str(number)
	return _text

func emit():
	if type == Type.STRING:
		emit_signal('changed', line_edit.text)
	elif type == Type.INTEGER:
		emit_signal('changed', line_edit.text.to_int())
	else:
		emit_signal('changed', line_edit.text.to_float())

func _on_line_edit_text_changed(new_text):
	var current_position = line_edit.caret_column
	
	set_value(new_text)
	
	line_edit.caret_column = current_position
	emit()

func _on_line_edit_gui_input(event):
	if type == Type.STRING or not event is InputEventKey or not editable:
		return
	
	var number
	if type == Type.INTEGER:
		number = line_edit.text.to_int()
	elif type == Type.FLOAT:
		number = line_edit.text.to_float()
	
	if event.keycode == KEY_UP and event.is_pressed():
		number += step
		set_value(number)
		line_edit.caret_column = line_edit.text.length()
		emit()
	elif event.keycode == KEY_DOWN and event.is_pressed():
		number -= step
		set_value(number)
		line_edit.caret_column = line_edit.text.length()
		emit()

func _on_reset_button_pressed():
	reset_butotn.hide()
	set_value(default_value)
	emit()

func set_editable(value : bool) -> void:
	editable = value
	line_edit.editable = editable
