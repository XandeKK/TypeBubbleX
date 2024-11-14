extends SubViewport

@onready var texture_rect : TextureRect = $TextureRect
@onready var color_rect : ColorRect = $ColorRect

var priority : int = 5
var index : int : set = _set_index

func _on_size_changed() -> void:
	color_rect.size = size
	texture_rect.size = size

func _set_index(value : int) -> void:
	index = value
