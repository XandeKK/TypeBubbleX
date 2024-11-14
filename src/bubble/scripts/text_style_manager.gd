class_name TextStyleManager
extends Node

var text_base : TextBase
var text_styles : Array[TextStyle] : get = _get_text_styles, set = _set_text_styles

func _init(_text_base : TextBase) -> void:
	text_base = _text_base

func _exit_tree() -> void:
	for text_style in text_styles:
		text_style.free()
	
	text_styles.clear()

func add(start : int, end : int) -> void:
	var text_style = TextStyle.new()
	
	text_style.text_base = text_base
	text_style.start = start
	text_style.end = end
	
	text_style.bold = text_base.bold
	text_style.italic = text_base.italic
	text_style.color = text_base.color
	text_style.font_size = text_base.font_size
	text_style.font_settings = text_base.font_settings
	text_style.uppercase = text_base.uppercase
	text_style.index = text_styles.size()
	text_style.text_styles_manager = self
	
	text_styles.append(text_style)

func remove(index : int) -> void:
	if index < 0 or index >= text_styles.size():
		push_error('Unable to remove. Index is out of range')
		return
	
	var text_style : TextStyle = text_styles[index]
	
	text_styles.remove_at(index)
	text_style.free()

func _get_text_styles() -> Array[TextStyle]:
	return text_styles

func _set_text_styles(value : Array[TextStyle]) -> void:
	text_styles = value

func to_dictionary() -> Dictionary:
	return {
		'text_styles': text_styles.map(func(text_style): return text_style.to_dictionary())
	}

func load(data : Dictionary) -> void:
	for text_style in data['text_styles']:
		add(text_style['start'], text_style['end'])
		text_styles[-1].load(text_style)
