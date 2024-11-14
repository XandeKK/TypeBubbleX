extends SubViewport

@onready var texture_rect : TextureRect = $TextureRect

var priority : int = 5
var index : int : set = _set_index

func _on_size_changed() -> void:
	texture_rect.size = size

func _set_index(value : int) -> void:
	index = value
