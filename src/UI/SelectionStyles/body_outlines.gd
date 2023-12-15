extends PanelContainer

@onready var vbox : VBoxContainer = $ScrollContainer/MarginContainer/VBoxContainer

var outline_item = load('res://src/UI/Styles/outline_item.tscn')
var node : TextStyle : set = _set_node

func _set_node(value : TextStyle) -> void:
	node = value
	for outline in node.outlines:
		var _outline = outline_item.instantiate()
		vbox.add_child(_outline)
		_outline.node = outline
		_outline.parent = self

func remove_outline(outline : Variant):
	var index = node.outlines.find(outline)
	node.remove_outline(index)

func _on_add_button_pressed():
	if not node:
		return
	
	node.add_outline()
	var outline = node.outlines[-1]
	var _outline = outline_item.instantiate()
	vbox.add_child(_outline)
	_outline.node = outline
	_outline.parent = self
