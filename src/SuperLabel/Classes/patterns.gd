extends Node
class_name Patterns

var parent : Control : set = _set_parent
var list : Array[TextureRect] : get = _get_list, set = _set_list

var pattern : PackedScene = load('res://src/SuperLabel/pattern.tscn')

func add() -> void:
	var _pattern = pattern.instantiate()
	parent.add_child(_pattern)
	list.append(_pattern)

func remove(index : int) -> void:
	if index < 0 or index >= list.size():
		push_error('Unable to remove. Index is out of range')
		return
	
	var texture_rect : TextureRect = list[index]
	
	list.remove_at(index)
	parent.remove_child(texture_rect)
	
	texture_rect.queue_free()

func _set_parent(value : Control) -> void:
	parent = value

func _get_list() -> Array[TextureRect]:
	return list

func _set_list(value : Array[TextureRect]) -> void:
	list = value
