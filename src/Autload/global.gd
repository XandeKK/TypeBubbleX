extends Node

var canvas : Canvas : set = set_canvas

signal canvas_setted

func set_canvas(value : Canvas) -> void:
	canvas = value
	emit_signal('canvas_setted')
