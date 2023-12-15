extends Button

var parent : Panel : set = set_parent

@onready var label : Label = $MarginContainer/HBoxContainer/Label

var node : Control : set = set_node

func set_node(value : Control) -> void:
	node = value
	label.text = node.text.text.replace('\n', ' ')
	node.text.text_changed.connect(_text_changed)

func _text_changed(value : String) -> void:
	label.text = value.replace('\n', ' ')

func _on_pressed():
	if node.focus:
		return
	node.set_focus(true)

func _on_remove_button_pressed():
	parent.remove_object(node)

func set_parent(value : Panel) -> void:
	parent = value

