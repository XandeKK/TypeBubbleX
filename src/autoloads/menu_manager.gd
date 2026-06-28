extends Node

signal context_changed(menu_structure : Dictionary)

func set_menu_context(menu_structure : Dictionary) -> void:
	context_changed.emit(menu_structure)
