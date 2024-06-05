@tool
extends VBoxContainer

var selected_tab : Node

func _ready():
	for child in get_children():
		child.connect('pressed', _selected)
		child.hide_content()
	
	if get_child_count() > 0:
		var child = get_child(0)
		child.select()
		selected_tab = child
	
func _selected(tab) -> void:
	if selected_tab == tab:
		return
	
	selected_tab.unselect()
	
	selected_tab = tab
	
	selected_tab.select()
