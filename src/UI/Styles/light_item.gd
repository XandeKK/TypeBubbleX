extends VBoxContainer

var node : Control : set = _set_node
var parent : Control : set = _set_parent

@onready var width_input : LineEdit = $WidthContainer/WidthInput
@onready var height_input : LineEdit = $HeightContainer/HeightInput
@onready var x_input : LineEdit = $XContainer/XInput
@onready var y_input : LineEdit = $YContainer/YInput
@onready var shape_option : OptionButton = $ShapeContainer/ShapeOptionButton
@onready var color_1_picker : ColorPickerButton = $Color1Container/Color1PickerButton
@onready var color_2_picker : ColorPickerButton = $Color2Container/Color2PickerButton

func _set_node(value : Control) -> void:
	node = value

func _set_parent(value : Control) -> void:
	parent = value

func _on_remove_button_pressed():
	parent.remove_light(node)
	queue_free()

func _on_width_input_changed(value):
	pass # Replace with function body.

func _on_height_input_changed(value):
	pass # Replace with function body.

func _on_x_input_changed(value):
	pass # Replace with function body.

func _on_y_input_changed(value):
	pass # Replace with function body.

func _on_color_1_picker_button_color_changed(color):
	pass # Replace with function body.

func _on_color_2_picker_button_color_changed(color):
	pass # Replace with function body.
