extends PanelContainer

@export var gradient_check_button : CheckButton

@onready var gradient_1d_texture_rect : TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/Gradient1DTextureRect
@onready var gradient_2d_texture_rect : TextureRect = $MarginContainer/VBoxContainer/Gradient2DTextureRect
@onready var shape_option_button : OptionButton = $MarginContainer/VBoxContainer/HBoxContainer2/ShapeOptionButton

var node : GradientText : set = _set_node

func blank_all() -> void:
	if not node:
		return
	
	node = null
	gradient_check_button.button_pressed = false
	gradient_1d_texture_rect.clear()
	shape_option_button.select(0)
	gradient_2d_texture_rect.clear()

func set_values(_node : GradientText) -> void:
	node = _node
	
	gradient_check_button.button_pressed = node.active
	shape_option_button.select(node.get_gradient_texture_2d().fill)
	gradient_1d_texture_rect.set_gradient(node.get_gradient())
	gradient_2d_texture_rect.set_gradient_text(node)

func _set_node(value : GradientText) -> void:
	node = value

func _on_shape_option_button_item_selected(index):
	if not node:
		return

	node.get_gradient_texture_2d().fill = index
	gradient_2d_texture_rect.set_fill(index)

func _on_gradient_check_button_toggled(toggled_on):
	if not node:
		return
	node.active = toggled_on
