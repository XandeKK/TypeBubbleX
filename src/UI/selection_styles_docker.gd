extends Panel

@export var canvas : SubViewportContainer

@onready var v_box : VBoxContainer = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/StylesVBoxContainer
@onready var rich_text_label : RichTextLabel = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/RichTextLabel

var style_item : PackedScene = load('res://src/UI/body_selection_styles.tscn')
var node : Control : set = _set_node

func _ready():
	canvas.object_focus_changed.connect(set_values)
	set_values(null)

func blank_all():
	rich_text_label.text = ''
	for child in v_box.get_children():
		child.queue_free()

func set_values(_node : Control):
	blank_all()
	node = _node
	if not node:
		return
	
	rich_text_label.text = node.text.text
	if not node.text.text_changed.is_connected(_text_changed):
		node.text.text_changed.connect(_text_changed)
	
	for text_style in node.text.text_styles.list:
		var _style_item = style_item.instantiate()
		v_box.add_child(_style_item)
		_style_item.node = text_style
		_style_item.parent = self

func _on_add_button_pressed():
	var selection_from : int = rich_text_label.get_selection_from()
	var selection_to : int = rich_text_label.get_selection_to()
	rich_text_label.deselect()

	if selection_from == -1 or selection_to == -1:
		# Add Alert
		return
	node.text.text_styles.add(selection_from, selection_to)
	
	var _style_item = style_item.instantiate()
	v_box.add_child(_style_item)
	_style_item.node = node.text.text_styles.list[-1]
	_style_item.parent = self

func _set_node(value : Control) -> void:
	node = value

func remove_selection_style(value : TextStyle):
	var index = node.text.text_styles.list.find(value)
	node.text.text_styles.remove(index)
	node.text._shape()

func _text_changed(value : String) -> void:
	rich_text_label.text = value
