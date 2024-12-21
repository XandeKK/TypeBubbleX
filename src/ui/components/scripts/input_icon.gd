@tool
extends PanelContainer

@onready var texture_rect : TextureRect = $TextureRect

@export var icon : Texture2D : set = _set_icon

func _ready() -> void:
	texture_rect.texture = icon

func _set_icon(value : Texture2D) -> void:
	icon = value
	
	if texture_rect != null:
		texture_rect.texture = icon
