extends VBoxContainer

@onready var blur_amount_input : _Input = $BlurAmountInput
@onready var blur_direction_x_input : _Input = $DirectionXInput
@onready var blur_direction_y_input : _Input = $DirectionYInput

var motion_blur : MotionBlur : set = set_motion_blur

func blank_all() -> void:
	motion_blur = null
	
	blur_amount_input.set_editable(false)
	blur_direction_x_input.set_editable(false)
	blur_direction_y_input.set_editable(false)

func set_values(value : MotionBlur) -> void:
	blank_all()
	
	motion_blur = value
	
	blur_amount_input.set_editable(true)
	blur_direction_x_input.set_editable(true)
	blur_direction_y_input.set_editable(true)

func set_motion_blur(value : MotionBlur) -> void:
	motion_blur = value
	
	if motion_blur:
		blur_amount_input.set_value(motion_blur.blur_amount)
		blur_direction_x_input.set_value(motion_blur.blur_direction_x)
		blur_direction_y_input.set_value(motion_blur.blur_direction_y)

func _on_direction_x_input_changed(value : float):
	motion_blur.blur_direction_x = value

func _on_direction_y_input_changed(value : float):
	motion_blur.blur_direction_y = value

func _on_blur_amount_input_changed(value : int):
	motion_blur.blur_amount = value
