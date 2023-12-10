extends LineEdit

enum Type {STRING, INTEGER, FLOAT}

@export var type : Type = Type.STRING
@export var step : float = 1.0
@export var suffix : String = ''

signal text_formatted

func _ready():
	if type == Type.STRING:
		text = '' if text.is_empty() else text
	if type == Type.INTEGER:
		text = '0' if text.is_empty() else text
	elif type == Type.FLOAT:
		text = '0.0' if text.is_empty() else text
	
	$Label.text = suffix

func _input(event):
	if type == Type.STRING:
		return
	if not event is InputEventKey:
		return
	
	var number
	if type == Type.INTEGER:
		number = text.to_int()
	elif type == Type.FLOAT:
		number = text.to_float()
	
	if event.keycode == KEY_UP:
		number += step
		formart_string(str(number))
		caret_column = text.length()
	elif event.keycode == KEY_DOWN:
		number -= step
		formart_string(str(number))
		caret_column = text.length()

func _on_text_changed(new_text : String):
	var current_position = caret_column
	
	formart_string(new_text)
	
	caret_column = current_position

func formart_string(new_text : String):
	if type == Type.INTEGER:
		var _text : int = new_text.to_int()
		text = str(_text if _text != 0 else '')
	elif type == Type.FLOAT:
		var _text : float
		if new_text.count('.') == 1 and new_text.ends_with('.'):
			_text = new_text.to_float()
			text = str(_text) + '.'
		else:
			_text = new_text.to_float()
			text = str(_text)
	emit_signal('text_formatted')
