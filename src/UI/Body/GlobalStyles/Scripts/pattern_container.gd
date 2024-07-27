extends VBoxContainer

@onready var active_check_button : CheckButton = $ActiveCheckButton
@onready var path_line_edit : LineEdit = $HBoxContainer/PathLineEdit
@onready var path_button : Button = $HBoxContainer/Button

var text : Text
var pattern : Pattern : set = set_pattern

func blank_all() -> void:
	text = null
	pattern = null
	
	active_check_button.set_pressed_no_signal(false)
	path_line_edit.editable = false
	path_button.disabled = true

func set_values(value : Text) -> void:
	blank_all()
	
	text = value
	
	if text.pattern:
		active(true)
		active_check_button.set_pressed_no_signal(true)

func set_pattern(value : Pattern) -> void:
	pattern = value
	
	if pattern:
		pass

func active(toggled_on : bool) -> void:
	if toggled_on:
		pattern = text.pattern
		
		path_line_edit.editable = true
		path_button.disabled = false
	else:
		pattern = null
		
		path_line_edit.editable = false
		path_button.disabled = true

func _on_active_check_button_toggled(toggled_on : bool):
	text.active_pattern(toggled_on)
	
	active(toggled_on)

func _on_button_pressed():
	pattern.load_image(path_line_edit.text)

func _on_clear_button_pressed():
	pattern.clear()
