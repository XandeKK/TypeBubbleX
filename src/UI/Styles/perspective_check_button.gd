extends CheckButton

var node : Control : set = _set_node

func blank_all() -> void:
	button_pressed = false

func set_values(_node : Control) -> void:
	node = _node
	button_pressed = node.perspective.active

func _set_node(value : Control) -> void:
	node = value

func _on_pressed():
	if not node:
		return
	
	node.perspective.active = button_pressed
