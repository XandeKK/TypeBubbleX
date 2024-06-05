@tool
extends PanelContainer

@onready var label : Label = $Label

@export var content : Node
@export_enum("TabVertical", "TabStyle") var theme_type: String = "TabVertical" : set = set_theme_type

enum State { HOVERED, SELECTED, UNSELECTED }
var state : State = State.UNSELECTED : set = set_state

signal pressed(node)

var tab_styles : Dictionary = {
	State.HOVERED: get_theme_stylebox("tab_hovered", theme_type),
	State.SELECTED: get_theme_stylebox("tab_selected", theme_type),
	State.UNSELECTED: get_theme_stylebox("tab_unselected", theme_type)
}

var label_colors : Dictionary = {
	State.HOVERED: get_theme_color("font_hovered_color", theme_type),
	State.SELECTED: get_theme_color("font_selected_color", theme_type),
	State.UNSELECTED: get_theme_color("font_unselected_color", theme_type)
}

func _ready():
	state = State.UNSELECTED
	label.text = tr(name)

func hide_content():
	if not content:
		return
	content.hide()

func show_content():
	if not content:
		return
	content.show()

func set_state(value : State) -> void:
	state = value
	
	add_theme_stylebox_override('panel', tab_styles[state])
	label.add_theme_color_override('font_color', label_colors[state])

func select() -> void:
	if state == State.SELECTED:
		return
	state = State.SELECTED
	show_content()

func unselect() -> void:
	if state == State.UNSELECTED:
		return
	state = State.UNSELECTED
	hide_content()

func _on_renamed():
	label.text = tr(name)

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			emit_signal('pressed', self)

func _on_mouse_entered():
	if state == State.SELECTED:
		return
	state = State.HOVERED

func _on_mouse_exited():
	if state == State.SELECTED:
		return
	state = State.UNSELECTED

func set_theme_type(value : String) -> void:
	theme_type = value
	tab_styles = {
		State.HOVERED: get_theme_stylebox("tab_hovered", theme_type),
		State.SELECTED: get_theme_stylebox("tab_selected", theme_type),
		State.UNSELECTED: get_theme_stylebox("tab_unselected", theme_type)
	}

	label_colors = {
		State.HOVERED: get_theme_color("font_hovered_color", theme_type),
		State.SELECTED: get_theme_color("font_selected_color", theme_type),
		State.UNSELECTED: get_theme_color("font_unselected_color", theme_type)
	}
