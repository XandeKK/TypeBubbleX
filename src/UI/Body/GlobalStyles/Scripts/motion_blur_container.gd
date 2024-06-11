extends VBoxContainer

@onready var active_check_button : CheckButton = $ActiveCheckButton
@onready var blur_amount_input : _Input = $BlurAmountInput
@onready var blur_direction_x_input : _Input = $DirectionXInput
@onready var blur_direction_y_input : _Input = $DirectionYInput

var text : Text
var motion_blur : MotionBlur : set = set_motion_blur

func blank_all() -> void:
	text = null
	motion_blur = null
	
	active_check_button.disabled = true
	active_check_button.set_pressed_no_signal(false)
	blur_amount_input.set_editable(false)
	blur_direction_x_input.set_editable(false)
	blur_direction_y_input.set_editable(false)

func set_values(value : Text) -> void:
	blank_all()
	
	text = value
	
	active_check_button.disabled = false
	
	if text.motion_blur:
		active_check_button.set_pressed_no_signal(true)
		active(true)

func set_motion_blur(value : MotionBlur) -> void:
	motion_blur = value
	
	if motion_blur:
		blur_amount_input.set_value(motion_blur.blur_amount)
		blur_direction_x_input.set_value(motion_blur.blur_direction_x)
		blur_direction_y_input.set_value(motion_blur.blur_direction_y)

func active(toggled_on : bool) -> void:
	if toggled_on:
		motion_blur = text.motion_blur
		
		blur_amount_input.set_editable(true)
		blur_direction_x_input.set_editable(true)
		blur_direction_y_input.set_editable(true)
	else:
		motion_blur = null
		
		blur_amount_input.set_editable(false)
		blur_direction_x_input.set_editable(false)
		blur_direction_y_input.set_editable(false)

func _on_active_check_button_toggled(toggled_on : bool):
	text.active_motion_blur(toggled_on)
	
	active(toggled_on)

func _on_direction_x_input_changed(value : float):
	motion_blur.blur_direction_x = value

func _on_direction_y_input_changed(value : float):
	motion_blur.blur_direction_y = value

func _on_blur_amount_input_changed(value : int):
	motion_blur.blur_amount = value

