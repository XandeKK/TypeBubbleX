extends PanelContainer

@onready var vbox : VBoxContainer = $ScrollContainer/MarginContainer/VBoxContainer

var outline_item = load('res://src/UI/Styles/outline_item.tscn')
var node : Control : set = _set_node

func blank_all() -> void:
	for child in vbox.get_children():
		vbox.remove_child(child)
		child.queue_free()

func set_values(_node : Control) -> void:
	node = _node.text.outlines
	for outline in node.get_outlines():
		var _outline = outline_item.instantiate()
		vbox.add_child(_outline)
		_outline.node = outline
		_outline.parent = self

func _set_node(value : Control) -> void:
	node = value

func remove_outline(outline : Control):
	node.remove(outline)

func _on_add_button_pressed():
	if not node:
		return
	node.add()
	var outline = node.get_outlines()[-1]
	var _outline = outline_item.instantiate()
	vbox.add_child(_outline)
	_outline.node = outline
	_outline.parent = self

