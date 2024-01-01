extends LineEdit

@export var step : float = 1.0
@export var max_value : float = 100.0
@export var min_value : float = 0.0
@export var suffix : String = ''

@onready var slider : HSlider = $HSlider

signal changed(value)

func _ready():
	text = '0.0' if text.is_empty() else text
	
	slider.max_value = max_value
	slider.min_value = min_value
	slider.step = step
	
	$Label.text = suffix

func _on_text_changed(new_text : String):
	var current_position = caret_column
	
	text = formart_string(new_text)
	
	slider.value = text.to_float()
	
	caret_column = current_position
	
	emit_signal('changed', text.to_float())

func formart_string(new_text : String):
	var number : float
	var _text : String
	if new_text.count('.') == 1 and new_text.ends_with('.'):
		number = new_text.to_float()
		_text = str(number) + '.'
	else:
		number = new_text.to_float()
		_text = str(number)
	
	return _text

func _on_gui_input(event):
	if not event is InputEventKey:
		return
	
	var number = text.to_float()
	
	if event.keycode == KEY_UP and event.is_pressed() and number < max_value:
		number += step
		set_value(number)
		caret_column = text.length()
		emit_signal('changed', text.to_float())
	elif event.keycode == KEY_DOWN and event.is_pressed() and number > min_value:
		number -= step
		set_value(number)
		caret_column = text.length()
		emit_signal('changed', text.to_float())

func _on_h_slider_value_changed(value):
	set_value(value)
	emit_signal('changed', text.to_float())

func set_value(value : float) -> void:
	text = formart_string(str(value))
	slider.value = value
