extends PanelContainer

@onready var vbox : VBoxContainer = $ScrollContainer/MarginContainer/VBoxContainer

var shake_item = load('res://src/UI/Styles/shake_item.tscn')
var node : Control : set = _set_node

func blank_all() -> void:
	for child in vbox.get_children():
		vbox.remove_child(child)

func set_values(_node : Control) -> void:
	print('opca')
	node = _node.text.shakes
	for shake in node.get_shakes():
		var _shake = shake_item.instantiate()
		vbox.add_child(_shake)
		_shake.node = shake
		_shake.parent = self

func _set_node(value : Control) -> void:
	node = value

func remove_shake(shake : Control):
	node.remove(shake)

func _on_add_button_pressed():
	print('wake me up')
	if not node:
		return
	print('wake me down')
	node.add()
	var shake = node.get_shakes()[-1]
	var _shake = shake_item.instantiate()
	vbox.add_child(_shake)
	_shake.node = shake
	_shake.parent = self
