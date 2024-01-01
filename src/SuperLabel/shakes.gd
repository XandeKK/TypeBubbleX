extends Control

var shake : PackedScene = load("res://src/SuperLabel/shake.tscn")
var shake_global : Control : get = _get_shake_global
var parent : Control : set = _set_parent

func add() -> void:
	var _shake = shake.instantiate()
	_shake.parent = parent
	add_child(_shake)

func remove(node : Control) -> void:
	remove_child(node)
	node.queue_free()

func get_shakes() -> Array:
	return get_children().filter(func(child): return child.is_global)

func _get_shake_global() -> Control:
	return shake_global

func set_shake_global() -> void:
	shake_global = shake.instantiate()
	shake_global.parent = parent
	add_child(shake_global)

func remove_shake_global() -> void:
	remove_child(shake_global)
	shake_global.queue_free()

func _set_parent(value : Control):
	parent = value

func to_dictionary() -> Dictionary:
	return {
		'list': get_shakes().map(func(_shake): return _shake.to_dictionary())
	}

func load(data : Dictionary) -> void:
	for _shake in data['list']:
		add()
		get_shakes()[-1].load(_shake)
