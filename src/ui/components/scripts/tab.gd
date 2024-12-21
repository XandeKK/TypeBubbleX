@tool
class_name Tab
extends Button

@export var content : PanelContainer

func _on_toggled(toggled_on: bool) -> void:
	if content == null:
		return
	
	content.visible = toggled_on
	
	for tab : Button in get_tree().get_nodes_in_group('tabs'):
		if tab == self:
			continue
		tab.content.hide()
		tab.set_pressed_no_signal(false)
