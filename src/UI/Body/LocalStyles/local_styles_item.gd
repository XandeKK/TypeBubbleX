extends PanelContainer

@onready var h_flow_container : HFlowContainer = $MarginContainer/VBoxContainer/HFlowContainer

@onready var properties_container : VBoxContainer = $MarginContainer/VBoxContainer/MarginContainer/PropertiesContainer
#@onready var outlines_container : VBoxContainer = $MarginContainer/VBoxContainer/MarginContainer/OutlinesContainer

var text_style : TextStyle : set = _set_text_style
var selected_tab : Node

func _ready():
	for child in h_flow_container.get_children():
		child.connect('pressed', _selected)
		child.hide_content()
	
	if h_flow_container.get_child_count() > 0:
		var child = h_flow_container.get_child(0)
		child.select()
		selected_tab = child

func _set_text_style(value : TextStyle) -> void:
	if not value:
		return
	
	text_style = value
	
	properties_container.text_style = text_style
	#outlines_container.text_style = text_style

func _on_remove_button_pressed():
	text_style.text_styles_manager.remove(text_style.index)
	text_style.text._shape()
	text_style.queue_free()
	
	queue_free()

func _selected(tab) -> void:
	if selected_tab == tab:
		return
	
	selected_tab.unselect()
	
	selected_tab = tab
	
	selected_tab.select()
