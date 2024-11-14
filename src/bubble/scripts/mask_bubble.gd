class_name MaskBubble
extends TextureRect

var bubble : Bubble
var brush_cursor : BrushCursor = preload('res://src/bubble/scenes/brush_cursor.tscn').instantiate()
@onready var sub_viewport : SubViewport = $SubViewport
@onready var sub_viewport_canvas : SubViewport = $SubViewport/SubViewportContainer/SubViewportCanvas
@onready var sub_viewport_container : SubViewportContainer = $SubViewport/SubViewportContainer
@onready var canvas : Mask = $SubViewport/SubViewportContainer/SubViewportCanvas/Canvas

var active : bool = true

func init(_bubble : Bubble) -> void:
	bubble = _bubble
	bubble.resized.connect(_on_resized)
	
	bubble.add_child(self)
	bubble.add_child(brush_cursor)
	
	canvas.brush_cursor = brush_cursor
	_on_resized()

func _exit_tree() -> void:
	brush_cursor.queue_free()

func _gui_input(event: InputEvent) -> void:
	if active:
		canvas.gui_input(event)
		if event as InputEventMouseMotion:
			brush_cursor.position = event.position

func _on_resized() -> void:
	sub_viewport_canvas.size = bubble.size
	sub_viewport_container.size = bubble.size
	canvas.size = bubble.size
	sub_viewport.size = bubble.size
	size = bubble.size

func to_dictionary() -> Dictionary:
	return {
		'canvas': canvas.to_dictionary()
	}

func load(data : Dictionary) -> void:
	canvas.load(data['canvas'])
