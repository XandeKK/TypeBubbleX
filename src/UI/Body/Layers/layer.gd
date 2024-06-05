extends PanelContainer

@onready var label : Label = $HBoxContainer/Label

enum State { HOVERED, SELECTED, UNSELECTED }
var state : State = State.UNSELECTED : set = set_state

var tab_styles : Dictionary = {
	State.HOVERED: get_theme_stylebox("tab_hovered", 'TabVertical'),
	State.SELECTED: get_theme_stylebox("tab_selected", 'TabVertical'),
	State.UNSELECTED: get_theme_stylebox("tab_unselected", 'TabVertical')
}

var label_colors : Dictionary = {
	State.HOVERED: get_theme_color("font_hovered_color", 'TabVertical'),
	State.SELECTED: get_theme_color("font_selected_color", 'TabVertical'),
	State.UNSELECTED: get_theme_color("font_unselected_color", 'TabVertical')
}

var bubble : Bubble : set = set_bubble

signal pressed(node)

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
	
	if not bubble.focus:
		bubble.set_focus(true)
		Global.canvas.camera.position = bubble.global_position + bubble.size / 2

func unselect() -> void:
	if state == State.UNSELECTED:
		return
	state = State.UNSELECTED

func set_bubble(value: Bubble) -> void:
	bubble = value
	label.text = bubble.text.text.replace('\n', ' ')
	bubble.text.text_changed.connect(on_text_changed)
	bubble.focus_changed.connect(on_focus_changed)
	
	if label.text.is_empty():
		label.text = "Layer"

func on_text_changed(value : String) -> void:
	label.text = value.replace('\n', ' ')

func on_focus_changed() -> void:
	if bubble.focus:
		emit_signal('pressed', self)

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

func _on_delete_button_pressed():
	Global.canvas.remove_bubble(bubble)
