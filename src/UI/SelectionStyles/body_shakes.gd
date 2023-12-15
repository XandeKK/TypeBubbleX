extends PanelContainer

@onready var vbox : VBoxContainer = $ScrollContainer/MarginContainer/VBoxContainer

var shake_item = load('res://src/UI/Styles/shake_item.tscn')
var node : TextStyle : set = _set_node

func _set_node(value : TextStyle) -> void:
	node = value
	for shake in node.shakes:
		var _shake = shake_item.instantiate()
		vbox.add_child(_shake)
		_shake.node = shake
		_shake.parent = self

func remove_shake(shake : Variant):
	var index = node.shakes.find(shake)
	node.remove_shake(index)

func _on_add_button_pressed():
	if not node:
		return
	
	node.add_shake()
	var shake = node.shakes[-1]
	var _shake = shake_item.instantiate()
	vbox.add_child(_shake)
	_shake.node = shake
	_shake.parent = self
