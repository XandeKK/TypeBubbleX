extends PanelContainer

@onready var vbox : VBoxContainer = $ScrollContainer/MarginContainer/VBoxContainer

var light_item = load('res://src/UI/Styles/light_item.tscn')
var node : Control : set = _set_node

func blank_all() -> void:
	for child in vbox.get_children():
		vbox.remove_child(child)

func set_values(_node : Control) -> void:
	node = _node.text.lights
	for light in node.get_light():
		var _light = light_item.instantiate()
		vbox.add_child(_light)
		_light.node = light
		_light.parent = self

func _set_node(value : Control) -> void:
	node = value

func remove_light(light : Control):
	node.remove(light)

func _on_add_button_pressed():
	if not node:
		return
	node.add()
	var light = node.list[-1]
	var _light = light_item.instantiate()
	vbox.add_child(_light)
	_light.node = light
	_light.parent = self

