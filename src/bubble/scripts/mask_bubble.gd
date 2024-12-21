class_name MaskBubble
extends TextureRect

var bubble : Bubble
var brush_cursor : BrushCursor = preload('res://src/bubble/scenes/brush_cursor.tscn').instantiate()
@onready var sub_viewport : SubViewport = $SubViewport
@onready var sub_viewport_canvas : SubViewport = $SubViewport/SubViewportContainer/SubViewportCanvas
@onready var sub_viewport_container : SubViewportContainer = $SubViewport/SubViewportContainer
@onready var mask : Mask = $SubViewport/SubViewportContainer/SubViewportCanvas/Mask

var enable : bool = true
var can_draw : bool = true : set = _set_can_draw

func init(_bubble : Bubble) -> void:
	bubble = _bubble
	bubble.resized.connect(_on_resized)
	
	bubble.add_child(self)
	bubble.add_child(brush_cursor)
	
	mask.brush_cursor = brush_cursor
	_on_resized()

func _exit_tree() -> void:
	brush_cursor.queue_free()

func _gui_input(event: InputEvent) -> void:
	if enable and can_draw:
		mask.gui_input(event)
		if event as InputEventMouseMotion:
			brush_cursor.position = event.position

func _on_resized() -> void:
	sub_viewport_canvas.size = bubble.size
	sub_viewport_container.size = bubble.size
	mask.size = bubble.size
	sub_viewport.size = bubble.size
	size = bubble.size

func _set_can_draw(value : bool) -> void:
	can_draw = value
	brush_cursor.can_draw = value

func to_dictionary() -> Dictionary:
	return {
		'mask': mask.to_dictionary()
	}

func load(data : Dictionary) -> void:
	mask.load(data['mask'])
	can_draw = false
