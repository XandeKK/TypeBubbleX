extends PanelContainer
class_name FontItemEdit

@onready var label : Label = $Label

enum State { HOVERED, SELECTED, UNSELECTED }
var state : State = State.UNSELECTED : set = set_state

signal pressed(node)

var tab_styles : Dictionary = {
	State.HOVERED: get_theme_stylebox("tab_hovered", "TabVertical"),
	State.SELECTED: get_theme_stylebox("tab_selected", "TabVertical"),
	State.UNSELECTED: get_theme_stylebox("tab_unselected", "TabVertical")
}

var label_colors : Dictionary = {
	State.HOVERED: get_theme_color("font_hovered_color", "TabVertical"),
	State.SELECTED: get_theme_color("font_selected_color", "TabVertical"),
	State.UNSELECTED: get_theme_color("font_unselected_color", "TabVertical")
}

func _ready():
	state = State.UNSELECTED

func set_state(value : State) -> void:
	state = value
	
	add_theme_stylebox_override('panel', tab_styles[state])
	label.add_theme_color_override('font_color', label_colors[state])

func select() -> void:
	if state == State.SELECTED:
		return
	state = State.SELECTED

func unselect() -> void:
	if state == State.UNSELECTED:
		return
	state = State.UNSELECTED

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
