extends VBoxContainer

@onready var active_check_button : CheckButton = $ActiveCheckButton
@onready var draw_check_button : CheckButton = $DrawCheckButton

var text_path : TextPath2D : set = set_text_path

func blank_all() -> void:
	text_path = null
	
	active_check_button.disabled = true
	draw_check_button.disabled = true

func set_values(value : TextPath2D) -> void:
	blank_all()
	
	text_path = value
	
	active_check_button.disabled = false
	draw_check_button.disabled = false

func set_text_path(value : TextPath2D) -> void:
	text_path = value
	
	if text_path:
		active_check_button.button_pressed = text_path.active
		draw_check_button.button_pressed = text_path.can_draw

func _on_active_check_button_toggled(toggled_on : bool):
	text_path.active = toggled_on
	draw_check_button.button_pressed = text_path.can_draw
	text_path.draw_()

func _on_draw_check_button_toggled(toggled_on):
	text_path.can_draw = toggled_on
	text_path.draw_()

func _on_reset_button_pressed():
	text_path.reset()
