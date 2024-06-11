extends Node

var canvas : Canvas : set = set_canvas

var mask : PackedScene = load("res://src/Bubble/mask.tscn")
var motion_blur : PackedScene = load("res://src/Bubble/motion_blur.tscn")
var blur : PackedScene = load("res://src/Bubble/blur.tscn")
var gradient : PackedScene = load("res://src/Bubble/gradient.tscn")

signal canvas_setted

func set_canvas(value : Canvas) -> void:
	canvas = value
	emit_signal('canvas_setted')
