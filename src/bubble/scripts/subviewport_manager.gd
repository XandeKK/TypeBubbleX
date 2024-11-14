class_name SubViewportManager
extends Object

var first_sub_viewport : SubViewport
# SubViewport with child TextureRect
var sub_viewports : Array[SubViewport] = []
var was_modified_by_user : bool = false

signal reconnected

func _init(_first_sub_viewport : SubViewport) -> void:
	first_sub_viewport = _first_sub_viewport

func get_texture() -> Texture:
	if sub_viewports.is_empty():
		return first_sub_viewport.get_texture()
	return sub_viewports[-1].get_texture()

func add(sub_viewport : SubViewport) -> void:
	sub_viewport.index = sub_viewports.size()
	sub_viewports.append(sub_viewport)
	
	if not was_modified_by_user:
		sort_according_priority()
	
	reconnect_sub_viewports()

func remove(index : int) -> void:
	if index < 0 or index >= sub_viewports.size():
		push_error("Index out of range")
		return
	
	sub_viewports.remove_at(index)
	
	reconnect_sub_viewports()

func move(source_index : int, target_index : int) -> void:
	if source_index < 0 or source_index >= sub_viewports.size() or target_index < 0 or target_index >= sub_viewports.size():
		push_error("Index out of range")
		return
	
	var source : SubViewport = sub_viewports.pop_at(source_index)
	
	sub_viewports.insert(target_index, source)
	was_modified_by_user = true
	reconnect_sub_viewports()

func reset() -> void:
	sort_according_priority()
	reconnect_sub_viewports()
	
	was_modified_by_user = false

func sort_according_priority() -> void:
	sub_viewports.sort_custom(sort_ascending)

func sort_ascending(sub_viewport_a : SubViewport, sub_viewport_b : SubViewport) -> bool:
	if sub_viewport_a.priority < sub_viewport_b.priority:
		return true
	return false

func reconnect_sub_viewports() -> void:
	for i in range(sub_viewports.size()):
		sub_viewports[i].index = i
		if i == 0:
			sub_viewports[i].texture_rect.texture = first_sub_viewport.get_texture()
		else:
			sub_viewports[i].texture_rect.texture = sub_viewports[i - 1].get_texture()
	
	reconnected.emit()

func resize_sub_viewports(_size : Vector2) -> void:
	for sub_viewport in sub_viewports:
		sub_viewport.size = _size
