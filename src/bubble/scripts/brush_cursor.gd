extends Control

var width : int : set = _set_width

func _draw() -> void:
	draw_circle(Vector2.ZERO, width, Color.WEB_GRAY, false)

func _set_width(value : int) -> void:
	width = value
	queue_redraw()
