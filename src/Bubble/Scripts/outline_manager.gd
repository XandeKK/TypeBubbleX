extends Control
class_name OutlineManager

@onready var outline_renderer_packed : PackedScene = load('res://src/Bubble/outline_renderer.tscn')
var text : Text : set = set_text

func get_outlines() -> Array:
	return get_children().filter(func(child): return child.global)

func add() -> Outline:
	var outline_renderer = outline_renderer_packed.instantiate()
	
	add_child(outline_renderer)
	
	outline_renderer.text = text
	outline_renderer.global = true
	
	return outline_renderer

func remove(outline_renderer : Outline) -> void:
	remove_child(outline_renderer)
	outline_renderer.queue_free()

func set_text(value : Text):
	text = value

func to_dictionary() -> Dictionary:
	return {
		'list': get_outlines().map(func(outline_renderer): return outline_renderer.to_dictionary())
	}

func load(data : Dictionary) -> void:
	for outline_renderer in data['list']:
		add()
		get_outlines()[-1].load(outline_renderer)
