extends LineEdit

enum Type {STRING, INTEGER, FLOAT}

@export var type : Type = Type.STRING
@export var step : float = 1.0
@export var suffix : String = ''

signal changed

func _ready():
	if type == Type.STRING:
		text = '' if text.is_empty() else text
	if type == Type.INTEGER:
		text = '0' if text.is_empty() else text
	elif type == Type.FLOAT:
		text = '0.0' if text.is_empty() else text
	
	$Label.text = suffix

func _on_gui_input(event):
	if type == Type.STRING:
		return
	if not event is InputEventKey:
		return
	
	var number
	if type == Type.INTEGER:
		number = text.to_int()
	elif type == Type.FLOAT:
		number = text.to_float()
	
	if event.keycode == KEY_UP and event.is_pressed():
		number += step
		text = formart_string(str(number))
		caret_column = text.length()
		emit_signal('changed')
	elif event.keycode == KEY_DOWN and event.is_pressed():
		number -= step
		text = formart_string(str(number))
		caret_column = text.length()
		emit_signal('changed')

func _on_text_changed(new_text : String):
	var current_position = caret_column
	
	text = formart_string(new_text)
	
	caret_column = current_position
	emit_signal('changed')

func formart_string(new_text : String):
	var number
	var _text : String
	if type == Type.INTEGER:
		number = new_text.to_int()
		_text = str(number if number != 0 else '')
	elif type == Type.FLOAT:
		if new_text.count('.') == 1 and new_text.ends_with('.'):
			number = new_text.to_float()
			_text = str(number) + '.'
		else:
			number = new_text.to_float()
			_text = str(number)
	return _text
