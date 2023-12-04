extends Control

#var shake : PackedScene = load("res://src/SuperLabel/shake.tscn")
var shake_global : Control : get = get_shake_global
var parent : Control : set = set_parent

func get_shake_global() -> Control:
	return shake_global

#func add() -> void:
#	var shake_global = shake.instantiate()
#	shake_global.parent = parent
#	add_child(shake_global)

func edit(properties : Dictionary) -> void:
	shake_global.set_properties(properties)

func remove() -> void:
	remove_child(shake_global)
	shake_global.queue_free()

func set_parent(value : Control):
	parent = value
