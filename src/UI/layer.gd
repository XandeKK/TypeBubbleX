extends Button

var parent : Panel : set = set_parent

var style_box_normal : StyleBoxFlat = get_theme_stylebox('normal').duplicate()
var normal_color : Color = style_box_normal.bg_color
var focused_color : Color = Color('66666699')

@onready var label : Label = $MarginContainer/HBoxContainer/Label

var node : Control : set = set_node

func _ready():
	add_theme_stylebox_override('normal', style_box_normal)

func set_node(value : Control) -> void:
	node = value
	label.text = node.text.text.replace('\n', ' ')
	node.text.text_changed.connect(_text_changed)
	node.focus_changed.connect(_focus_changed)

func _text_changed(value : String) -> void:
	label.text = value.replace('\n', ' ')

func _focus_changed() -> void:
	if node.focus:
		grab_focus()
		style_box_normal.bg_color = focused_color
	else:
		style_box_normal.bg_color = normal_color

func _on_pressed():
	if node.focus:
		return
	node.set_focus(true)

	parent.set_position_camera(node)

func _on_remove_button_pressed():
	parent.remove_object(node)

func set_parent(value : Panel) -> void:
	parent = value

