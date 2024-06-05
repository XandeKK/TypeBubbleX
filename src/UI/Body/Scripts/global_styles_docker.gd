extends PanelContainer

@onready var h_flow_container : HFlowContainer = $VBoxContainer/MarginContainer/VBoxContainer/HFlowContainer

@onready var outlines_container : VBoxContainer = $VBoxContainer/MarginContainer2/OutlinesContainer
@onready var motion_blur_container : VBoxContainer = $VBoxContainer/MarginContainer2/MotionBlurContainer
@onready var blur_container : VBoxContainer = $VBoxContainer/MarginContainer2/BlurContainer
@onready var perspective_container : VBoxContainer = $VBoxContainer/MarginContainer2/PerspectiveContainer
@onready var gradient_container : VBoxContainer = $VBoxContainer/MarginContainer2/GradientContainer
@onready var mask_container : VBoxContainer = $VBoxContainer/MarginContainer2/MaskContainer

var selected_tab : Node

func _ready():
	for child in h_flow_container.get_children():
		child.connect('pressed', _selected)
		child.hide_content()
	
	if h_flow_container.get_child_count() > 0:
		var child = h_flow_container.get_child(0)
		child.select()
		selected_tab = child
		
	if Global.canvas:
		connect_canvas()
	else:
		Global.canvas_setted.connect(connect_canvas)

	set_values(null)

func connect_canvas() -> void:
	Global.canvas.bubble_focus_changed.connect(set_values)

func blank_all():
	outlines_container.blank_all()
	motion_blur_container.blank_all()
	blur_container.blank_all()
	perspective_container.blank_all()
	gradient_container.blank_all()
	mask_container.blank_all()

func set_values(bubble : Bubble):
	if not bubble:
		blank_all()
		return

	outlines_container.set_values(bubble.text.outline_manager)
	motion_blur_container.set_values(bubble.text.motion_blur)
	blur_container.set_values(bubble.text)
	perspective_container.set_values(bubble.perspective)
	gradient_container.set_values(bubble.text.gradient)
	mask_container.set_values(bubble.mask)

func _selected(tab) -> void:
	if selected_tab == tab:
		return
	
	selected_tab.unselect()
	
	selected_tab = tab
	
	selected_tab.select()
