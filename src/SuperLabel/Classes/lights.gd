extends Node
class_name Lights

var parent : Control : set = _set_parent
var list : Array[TextureRect] : get = _get_list, set = _set_list
var light : PackedScene = load("res://src/SuperLabel/light.tscn")

func add() -> void:
	var _light = light.instantiate()
	parent.add_child(_light)
	list.append(_light)

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

func to_dictionary() -> Dictionary:
	return {
		#'list': list.map(func(light): return light.to_dictionary())
	}
