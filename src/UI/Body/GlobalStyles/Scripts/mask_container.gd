extends VBoxContainer

@onready var active_check_button : CheckButton = $ActiveCheckButton
@onready var opacity_h_slider : HSlider = $HBoxContainer/OpacityHSlider
@onready var radius_h_slider : HSlider = $HBoxContainer2/RadiusHSlider
@onready var opacity_number_label : Label = $HBoxContainer/OpacityNumberLabel
@onready var radius_number_label : Label = $HBoxContainer2/RadiusNumberLabel

var mask : Mask : set = set_mask

func blank_all() -> void:
	mask = null
	
	active_check_button.disabled = true
	opacity_h_slider.editable = false
	radius_h_slider.editable = false

func set_values(value : Mask) -> void:
	blank_all()
	
	mask = value
	
	active_check_button.disabled = false
	opacity_h_slider.editable = true
	radius_h_slider.editable = true

func set_mask(value : Mask) -> void:
	mask = value
	
	if mask:
		active_check_button.button_pressed = mask.active
		opacity_h_slider.value = mask.brush.alpha
		radius_h_slider.value = mask.brush.radius

func _on_active_check_button_toggled(toggled_on : bool):
	mask.active = toggled_on

func _on_opacity_h_slider_value_changed(value : float):
	mask.brush.alpha = value
	opacity_number_label.text = str(value)

func _on_radius_h_slider_value_changed(value : float):
	mask.brush.radius = value as int
	radius_number_label.text = str(value)

func _on_reset_button_pressed():
	mask.reset()
