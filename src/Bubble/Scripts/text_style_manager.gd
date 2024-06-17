class_name TextStyleManager

var text : Text : set = _set_text
var list : Array[TextStyle] : get = _get_list, set = _set_list

func add(start : int, end : int) -> void:
	var text_style = TextStyle.new()
	text_style.text = text
	text_style.start = start
	text_style.end = end
	text_style.bold = text.bold
	text_style.italic = text.italic
	text_style.color = text.color
	text_style.font_size = text.font_size
	text_style.font_settings = text.font_settings
	text_style.uppercase = text.uppercase
	text_style.index = list.size()
	text_style.text_styles_manager = self
	
	list.append(text_style)

func remove(index : int) -> void:
	if index < 0 or index >= list.size():
		push_error('Unable to remove. Index is out of range')
		return
	list.remove_at(index)

func _set_text(value : Text) -> void:
	text = value

func _get_list() -> Array[TextStyle]:
	return list

func _set_list(value : Array[TextStyle]) -> void:
	list = value

func to_dictionary() -> Dictionary:
	return {
		'list': list.map(func(text_style): return text_style.to_dictionary())
	}

func load(data : Dictionary) -> void:
	for text_style in data['list']:
		add(text_style['start'], text_style['end'])
		list[-1].load(text_style)
