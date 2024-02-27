extends PanelContainer

@onready var blur_option_button : OptionButton = $MarginContainer/VBoxContainer/HBoxContainer/BlurOptionButton
@onready var input_blur_size : LineEdit = $MarginContainer/VBoxContainer/HBoxContainer2/InputBlurSize

var node : Control : set = _set_node
var selected_blur : ColorRect

func blank_all() -> void:
	if not node:
		return
	
	node = null
	blur_option_button.select(0)
	input_blur_size.text = '0'

func set_values(_node : Control) -> void:
	node = _node.text

	if node.blur.visible:
		selected_blur = node.blur
		blur_option_button.select(0)
	else:
		selected_blur = node.blur_outline
		blur_option_button.select(1)
	
	input_blur_size.text = str(selected_blur.blur_size)

func _set_node(value : Control) -> void:
	node = value

func _on_blur_option_button_item_selected(index):
	if not node:
		return
	
	selected_blur.visible = false
	selected_blur.blur_size = 0
	input_blur_size.text = '0'

	if index == 0:
		selected_blur = node.blur
	else:
		selected_blur = node.blur_outline
	
	selected_blur.visible = true
	selected_blur.blur_size = 0

func _on_input_blur_size_changed(value):
	selected_blur.blur_size = value
