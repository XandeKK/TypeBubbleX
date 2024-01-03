extends VBoxContainer

var node : Control
var parent : Control : set = _set_parent

@onready var fov : LineEdit = $FOVContainer/FOVInput
@onready var x : LineEdit = $XContainer/XInput
@onready var y : LineEdit = $YContainer/YInput
@onready var insert : LineEdit = $InsertContainer/InsertInput
@onready var cull_back : CheckButton = $CullBackContainer/CullBackCheckButton

func blank_all():
	node = null
	fov.set_value(90)
	x.set_value(0)
	y.set_value(0)
	insert.set_value(0)
	cull_back.button_pressed = true

func set_values(value : Control) -> void:
	node = value
	fov.set_value(node.sub_viewport_container.material.get_shader_parameter('fov'))
	x.set_value(node.sub_viewport_container.material.get_shader_parameter('x_rot'))
	y.set_value(node.sub_viewport_container.material.get_shader_parameter('y_rot'))
	insert.set_value(node.sub_viewport_container.material.get_shader_parameter('inset'))
	cull_back.button_pressed = node.sub_viewport_container.material.get_shader_parameter('cull_back')

func _set_parent(value : Control) -> void:
	parent = value

func _on_fov_input_changed(value):
	if not node:
		return
	node.sub_viewport_container.material.set_shader_parameter("fov", value)

func _on_x_input_changed(value):
	if not node:
		return
	node.sub_viewport_container.material.set_shader_parameter("x_rot", value)

func _on_y_input_changed(value):
	if not node:
		return
	node.sub_viewport_container.material.set_shader_parameter("y_rot", value)

func _on_insert_input_changed(value):
	if not node:
		return
	node.sub_viewport_container.material.set_shader_parameter("inset", value)

func _on_cull_back_check_button_toggled(toggled_on):
	if not node:
		return
	node.sub_viewport_container.material.set_shader_parameter("cull_back", toggled_on)
