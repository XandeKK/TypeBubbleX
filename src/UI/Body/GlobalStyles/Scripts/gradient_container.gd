extends VBoxContainer

@onready var active_check_button : CheckButton = $ScrollContainer/VBoxContainer/ActiveCheckButton
@onready var body_gradient : PanelContainer = $ScrollContainer/VBoxContainer/BodyGradient

var gradient : GradientText : set = set_gradient

func blank_all() -> void:
	gradient = null
	
	active_check_button.disabled = true

func set_values(value : GradientText) -> void:
	blank_all()
	
	gradient = value
	
	active_check_button.disabled = false

func set_gradient(value : GradientText) -> void:
	gradient = value
	
	if gradient:
		active_check_button.button_pressed = gradient.active
		body_gradient.set_values(gradient)

func _on_active_check_button_toggled(toggled_on : bool):
	gradient.active = toggled_on
