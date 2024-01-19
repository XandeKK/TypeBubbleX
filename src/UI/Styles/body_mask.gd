extends PanelContainer

@export var active_check_button : CheckButton

@onready var mode_option_button : OptionButton = $MarginContainer/VBoxContainer/HBoxContainer/ModeOptionButton
@onready var draw_check_button : CheckButton = $MarginContainer/VBoxContainer/DrawCheckButton

var node : Control

func blank_all() -> void:
	mode_option_button.select(0)
	draw_check_button.button_pressed = false

func set_values(_node : Control) -> void:
	node = _node.mask_draw
	
	active_check_button.button_pressed = node.active
	mode_option_button.select(node.mode)
	draw_check_button.button_pressed = node.can_draw

func _on_mode_option_button_item_selected(index):
	if not node:
		return

	node.mode = index

func _on_draw_check_button_toggled(toggled_on):
	if not node:
		return

	node.can_draw = toggled_on

func _on_mask_check_button_toggled(toggled_on):
	if not node:
		return
	
	node.active = toggled_on
