extends PanelContainer

@onready var perspective : VBoxContainer = $ScrollContainer/MarginContainer/Perspective

func blank_all() -> void:
	perspective.blank_all()

func set_values(_node : Control) -> void:
	perspective.set_values(_node)
