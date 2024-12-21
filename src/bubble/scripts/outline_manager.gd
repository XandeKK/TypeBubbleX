class_name OutlineManager
extends Control

var text : Text : set = set_text

func get_outlines() -> Array:
	return get_children()

func add() -> Outline:
	var outline : Outline = Global.outline_scene.instantiate()
	
	add_child(outline)
	
	outline.text = text
	outline.size = size
	
	return outline

func remove(outline : Outline) -> void:
	remove_child(outline)
	
	outline.queue_free()

func set_text(value : Text):
	text = value

func _on_resized() -> void:
	for outline : Outline in get_outlines():
		outline.size = size

func to_dictionary() -> Dictionary:
	return {
		'outlines': get_outlines().map(func(outline : Outline): return outline.to_dictionary())
	}

func load(data : Dictionary) -> void:
	for outline : Dictionary in data['outlines']:
		add()
		get_outlines()[-1].load(outline)
