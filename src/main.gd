extends Control

@onready var canvas : SubViewportContainer = $MarginContainer/VBoxContainer/MarginContainer/HSplitContainer/HSplitContainer/Canvas/TopCanvas
@onready var notifications_box : VBoxContainer = $NotificationsBox

func _ready():
	FileHandler.canvas = canvas
	Notification.v_box_container = notifications_box
