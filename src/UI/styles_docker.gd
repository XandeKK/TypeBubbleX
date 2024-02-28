extends Panel

@export var canvas : SubViewportContainer

@onready var body_perspective : PanelContainer = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/BodyPerspective
@onready var body_outlines : PanelContainer = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/BodyOutlines
@onready var body_shakes : PanelContainer = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/BodyShakes
@onready var body_blur : PanelContainer = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/BodyBlur
@onready var body_gradient : PanelContainer = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/BodyGradient
@onready var body_mask : PanelContainer = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/BodyMask

func _ready():
	canvas.object_focus_changed.connect(set_values)
	set_values(null)

func blank_all():
	body_perspective.blank_all()
	body_outlines.blank_all()
	body_shakes.blank_all()
	body_blur.blank_all()
	body_gradient.blank_all()
	body_mask.blank_all()

func set_values(node : Control):
	blank_all()
	if not node:
		return
	
	body_perspective.set_values(node)
	body_outlines.set_values(node)
	body_shakes.set_values(node)
	body_blur.set_values(node)
	body_gradient.set_values(node.text.gradient_text)
	body_mask.set_values(node)
