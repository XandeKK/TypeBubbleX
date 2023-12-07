extends Control

@onready var sub_viewport : SubViewport = $SubViewport
@onready var text : Control = $SubViewport/Text
@onready var texture_rect : TextureRect = $TextureRect

var move : Move = Move.new()

func _ready():
	move.target = self
	resized.connect(readjust_size)
	readjust_size()

func _input(event):
	move.input(event)

func readjust_size():
	sub_viewport.size = size
	text.size = size
	texture_rect.size = size
	
	pivot_offset = size / 2
	
	text._shape()
