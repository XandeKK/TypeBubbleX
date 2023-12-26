extends Node
class_name TextStyles

var parent : Control : set = _set_parent
var list : Array[TextStyle] : get = _get_list, set = _set_list

func add(start : int, end : int) -> void:
	var text_style = TextStyle.new()
	text_style.parent = parent
	text_style.start = start
	text_style.end = end
	text_style.bold = parent.bold
	text_style.italic = parent.italic
	text_style.color = parent.color
	text_style.font_size = parent.font_size
	text_style.font_settings = parent.font_settings
	text_style.uppercase = parent.uppercase
	
	list.append(text_style)

func remove(index : int) -> void:
	if index < 0 or index >= list.size():
		push_error('Unable to remove. Index is out of range')
		return
	list.remove_at(index)

func _set_parent(value : Control) -> void:
	parent = value

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
