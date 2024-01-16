extends Panel

@export var canvas : SubViewportContainer

@onready var perspective_check_button : CheckButton = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/HeaderPerspective/PerspectiveCheckButton
@onready var body_outlines : PanelContainer = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/BodyOutlines
@onready var body_shakes : PanelContainer = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/BodyShakes
@onready var body_gradient : PanelContainer = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/BodyGradient

func _ready():
	canvas.object_focus_changed.connect(set_values)
	set_values(null)

func blank_all():
	perspective_check_button.blank_all()
	body_outlines.blank_all()
	body_shakes.blank_all()
	body_gradient.blank_all()

func set_values(node : Control):
	blank_all()
	if not node:
		return
	
	perspective_check_button.set_values(node)
	body_outlines.set_values(node)
	body_shakes.set_values(node)
	body_gradient.set_values(node)
