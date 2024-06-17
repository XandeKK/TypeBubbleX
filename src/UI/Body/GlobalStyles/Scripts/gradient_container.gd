extends VBoxContainer

@onready var active_check_button : CheckButton = $ScrollContainer/VBoxContainer/ActiveCheckButton
@onready var body_gradient : PanelContainer = $ScrollContainer/VBoxContainer/BodyGradient

var text : Text
var gradient : GradientText : set = set_gradient

func blank_all() -> void:
	text = null
	gradient = null
	
	active_check_button.set_pressed_no_signal(false)
	active_check_button.disabled = true
	body_gradient.blank_all()

func set_values(value : Text) -> void:
	blank_all()
	
	text = value
	
	active_check_button.disabled = false
	
	if text.gradient:
		active_check_button.set_pressed_no_signal(true)
		
		active(true)

func set_gradient(value : GradientText) -> void:
	gradient = value
	
	if gradient:
		body_gradient.set_values(gradient)

func active(toggled_on : bool) -> void:
	if toggled_on:
		gradient = text.gradient
	else:
		gradient = null
		body_gradient.blank_all()

func _on_active_check_button_toggled(toggled_on : bool):
	text.active_gradient(toggled_on)
	
	active(toggled_on)
