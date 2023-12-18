extends Control

@onready var canvas : SubViewportContainer = $MarginContainer/VBoxContainer/MarginContainer/HSplitContainer/HSplitContainer/Canvas/TopCanvas

func _ready():
	FileHandler.canvas = canvas
