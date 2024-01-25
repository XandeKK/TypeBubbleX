extends Node

var base_notification : PackedScene = load('res://src/UI/Notifications/base_notification.tscn')

var v_box_container : VBoxContainer

func message(message : String, timer : float = 1.0) -> void:
	var _base_notification = base_notification.instantiate()
	v_box_container.add_child(_base_notification)
	_base_notification.init(message)
