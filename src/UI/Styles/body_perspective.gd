extends PanelContainer

@export var active_check_button : CheckButton

var node : Control

func blank_all() -> void:
	active_check_button.button_pressed = false

func set_values(_node : Control) -> void:
	node = _node.perspective
	active_check_button.button_pressed = node.active

func _on_perspective_check_button_toggled(toggled_on):
	if not node:
		return
	
	node.active = toggled_on

func _on_reset_button_pressed():
	if not node:
		return
	
	node.reset()
