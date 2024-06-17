extends VBoxContainer

@onready var active_check_button : CheckButton = $ActiveCheckButton
@onready var blur_size_input : _Input = $BlurSizeInput

var text : Text
var blur : Blur : set = set_blur

func blank_all() -> void:
	text = null
	blur = null
	
	active_check_button.disabled = true
	active_check_button.set_pressed_no_signal(false)
	blur_size_input.set_editable(false)

func set_values(value : Text) -> void:
	blank_all()
	
	text = value
	
	active_check_button.disabled = false
	
	if text.blur:
		active_check_button.set_pressed_no_signal(true)
		blur_size_input.set_editable(true)
		
		active(true)

func set_blur(value : Blur) -> void:
	blur = value
	
	if blur:
		blur_size_input.set_value(text.blur.blur_size)

func active(toggled_on : bool) -> void:
	if toggled_on:
		blur = text.blur
		
		blur_size_input.set_editable(true)
	else:
		blur = null
		
		blur_size_input.set_editable(false)

func _on_active_check_button_toggled(toggled_on : bool):
	text.active_blur(toggled_on)
	
	active(toggled_on)

func _on_blur_size_input_changed(value : int):
	text.blur.blur_size = value
