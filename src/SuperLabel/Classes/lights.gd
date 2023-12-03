extends Node
class_name Lights

var parent : Control : set = set_parent
var list : Array[TextureRect] : get = get_list, set = set_list
#var light : PackedScene = load()

func add() -> void:
#	var _light = light.instantiate()
#	parent.add_child(_light)
#	list.append(_light)
	pass

func remove(index : int) -> void:
	if index < 0 or index >= list.size():
		push_error('Unable to remove. Index is out of range')
		return
	
	var texture_rect : TextureRect = list[index]
	
	list.remove_at(index)
	parent.remove_child(texture_rect)
	
	texture_rect.queue_free()

func set_parent(value : Control) -> void:
	parent = value

func get_list() -> Array[TextureRect]:
	return list

func set_list(value : Array[TextureRect]) -> void:
	list = value
