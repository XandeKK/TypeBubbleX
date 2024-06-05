extends Control

@onready var x_input : _Input = $XInput
@onready var y_input : _Input = $YInput
@onready var outline_size_input : _Input = $OutlineSizeInput
@onready var blur_size_input : _Input = $BlurSizeInput
@onready var input_color : _InputColor = $InputColor
@onready var only_outline_check_button : CheckButton = $OnlyOutlineCheckButton
@onready var active_gradient_check_button : CheckButton = $ActiveGradientCheckButton
@onready var body_gradient : PanelContainer = $BodyGradient

var outline : Outline : set = set_outline
var outline_manager : OutlineManager : set = set_outline_manager

func _on_x_input_changed(value : int):
	outline.offset.x = value

func _on_y_input_changed(value : int):
	outline.offset.y = value

func _on_outline_size_input_changed(value : int):
	outline.outline_size = value

func _on_blur_size_input_changed(value : int):
	outline.blur_size = value

func _on_input_color_changed(value : Color):
	outline.color = value

func _on_only_outline_check_button_toggled(toggled_on : bool):
	outline.only_outline = toggled_on

func set_outline(value : Outline) -> void:
	outline = value
	
	x_input.set_value(outline.offset.x)
	y_input.set_value(outline.offset.y)
	outline_size_input.set_value(outline.outline_size)
	blur_size_input.set_value(outline.blur_size)
	input_color.set_color(outline.color)
	only_outline_check_button.button_pressed = outline.only_outline
	active_gradient_check_button.button_pressed = outline.gradient.active
	body_gradient.set_values(outline.gradient)

func set_outline_manager(value : OutlineManager) -> void:
	outline_manager = value

func _on_remove_button_pressed():
	outline_manager.remove(outline)
	queue_free()

func _on_active_gradient_check_button_toggled(toggled_on : bool):
	outline.gradient.active = toggled_on
