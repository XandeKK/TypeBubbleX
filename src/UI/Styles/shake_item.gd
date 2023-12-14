extends VBoxContainer

var node : Control : set = _set_node
var parent : Control : set = _set_parent

@onready var two_direction_button : CheckButton = $TwoDirectionContainer/TwoDirectionCheckButton
@onready var x_input : LineEdit = $XContainer/XInput
@onready var y_input : LineEdit = $YContainer/YInput
@onready var intensity_input : LineEdit = $IntensityContainer/IntensityInput
@onready var quantity_input : LineEdit = $QuantityContainer/QuantityInput
@onready var alpha_input : LineEdit = $AlphaContainer/AlphaInput

func _set_node(value : Control) -> void:
	node = value
	two_direction_button.button_pressed = node.two_direction
	x_input.text = str(node.x)
	y_input.text = str(node.y)
	intensity_input.text = str(node.intensity)
	quantity_input.text = str(node.quantity)
	alpha_input.set_value(node.alpha)

func _set_parent(value : Control) -> void:
	parent = value

func _on_x_input_changed(value):
	node.x = value

func _on_y_input_changed(value):
	node.y = value

func _on_remove_button_pressed():
	parent.remove_shake(node)
	queue_free()

func _on_intensity_input_changed(value):
	node.intensity = value

func _on_quantity_input_changed(value):
	node.quantity = value

func _on_alpha_input_changed(value):
	node.alpha = value
