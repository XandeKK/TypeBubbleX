extends VBoxContainer

@onready var active_check_button : CheckButton = $ActiveCheckButton
@onready var reset_button : Button = $ResetButton

var perspective : Perspective : set = set_perspective

func blank_all() -> void:
	perspective = null
	
	active_check_button.disabled = true
	reset_button.disabled = true

func set_values(value : Perspective) -> void:
	blank_all()
	
	perspective = value
	
	active_check_button.disabled = false
	reset_button.disabled = false

func set_perspective(value : Perspective) -> void:
	perspective = value
	
	if perspective:
		active_check_button.button_pressed = perspective.active

func _on_active_check_button_toggled(toggled_on : bool):
	perspective.active = toggled_on

func _on_reset_button_pressed():
	perspective.reset()
