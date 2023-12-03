extends Node
class_name TextStyles

var parent : Control : set = set_parent
var list : Array[Dictionary] : get = get_list, set = set_list

func add(start : int, end : int) -> void:
	var text_style = TextStyle.new()
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

func get_list() -> Array:
	return list

func set_list(value : Array[Dictionary]) -> void:
	list = value

func set_parent(value : Control) -> void:
	parent = value
