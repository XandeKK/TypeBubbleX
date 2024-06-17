extends PanelContainer

@onready var shape_option_button : OptionButton = $MarginContainer/VBoxContainer/HBoxContainer/ShapeOptionButton
@onready var gradient_1d_texture_rect : TextureRect = $MarginContainer/VBoxContainer/HBoxContainer2/Gradient1DTextureRect
@onready var gradient_2d_texture_rect : TextureRect = $MarginContainer/VBoxContainer/Gradient2DTextureRect

var gradient : GradientText : set = _set_gradient

func blank_all() -> void:
	if not gradient:
		return
	
	gradient = null
	
	shape_option_button.select(0)
	gradient_1d_texture_rect.blank_all()
	gradient_2d_texture_rect.blank_all()

func set_values(value : GradientText) -> void:
	blank_all()
	
	gradient = value

func _set_gradient(value : GradientText) -> void:
	gradient = value
	
	if gradient:
		shape_option_button.select(gradient.get_gradient_texture_2d().fill)
		gradient_1d_texture_rect.set_values(gradient.get_gradient())
		gradient_2d_texture_rect.set_values(gradient.get_gradient_texture_2d())

func _on_shape_option_button_item_selected(index : int):
	@warning_ignore("int_as_enum_without_cast")
	gradient.get_gradient_texture_2d().fill = index
	gradient_2d_texture_rect.set_fill(index)
	
