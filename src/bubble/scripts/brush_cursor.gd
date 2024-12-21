class_name BrushCursor
extends Control

var width : int : set = _set_width
var can_draw : bool = true : set = _set_can_draw

func _draw() -> void:
	if not can_draw:
		return
	
	draw_circle(Vector2.ZERO, width, Color.WEB_GRAY, false)

func _set_width(value : int) -> void:
	width = value
	queue_redraw()

func _set_can_draw(value : bool) -> void:
	can_draw = value
	queue_redraw()
