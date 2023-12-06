extends Control

@onready var sub_viewport : SubViewport = $SubViewport
@onready var text : Control = $SubViewport/Text
@onready var texture_rect : TextureRect = $TextureRect

func _ready():
	resized.connect(readjust_size)
	readjust_size()

func readjust_size():
	sub_viewport.size = size
	text.size = size
	texture_rect.size = size
	
	pivot_offset = size / 2
	
	text._shape()
