extends VBoxContainer

@onready var active_check_button : CheckButton = $ActiveCheckButton
@onready var drawing_check_button : CheckButton = $DrawingCheckButton
@onready var opacity_h_slider : HSlider = $HBoxContainer/OpacityHSlider
@onready var radius_h_slider : HSlider = $HBoxContainer2/RadiusHSlider
@onready var opacity_number_label : Label = $HBoxContainer/OpacityNumberLabel
@onready var radius_number_label : Label = $HBoxContainer2/RadiusNumberLabel

var bubble : Bubble
var mask : Mask : set = set_mask

func blank_all() -> void:
	bubble = null
	mask = null
	
	active_check_button.set_pressed_no_signal(false)
	drawing_check_button.disabled = true
	drawing_check_button.set_pressed_no_signal(false)
	opacity_h_slider.editable = false
	radius_h_slider.editable = false

func set_values(value : Bubble) -> void:
	blank_all()
	
	bubble = value
	
	if bubble.mask:
		active(true)
		active_check_button.set_pressed_no_signal(true)

func set_mask(value : Mask) -> void:
	mask = value
	
	if mask:
		drawing_check_button.set_pressed_no_signal(mask.active)
		opacity_h_slider.value = mask.brush.alpha
		radius_h_slider.value = mask.brush.radius

func active(toggled_on : bool) -> void:
	if toggled_on:
		mask = bubble.mask
		
		drawing_check_button.disabled = false
		opacity_h_slider.editable = true
		radius_h_slider.editable = true
	else:
		mask = null
		
		drawing_check_button.disabled = true
		opacity_h_slider.editable = false
		radius_h_slider.editable = false

func _on_active_check_button_toggled(toggled_on : bool):
	bubble.active_mask(toggled_on)
	
	active(toggled_on)

func _on_opacity_h_slider_value_changed(value : float):
	mask.brush.alpha = value
	opacity_number_label.text = str(value)

func _on_radius_h_slider_value_changed(value : float):
	mask.brush.radius = value as int
	radius_number_label.text = str(value)

func _on_reset_button_pressed():
	mask.reset()

func _on_drawing_check_button_toggled(toggled_on):
	mask.active = toggled_on
