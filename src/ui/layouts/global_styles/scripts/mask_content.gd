extends PanelContainer

@onready var enable : CheckButton = $VBoxContainer/Enable
@onready var drawing : CheckButton = $VBoxContainer/Drawing
@onready var opacity : HSlider = $VBoxContainer/HBoxContainer/Opacity
@onready var opacity_number : Label = $VBoxContainer/HBoxContainer/OpacityNumber
@onready var radius : HSlider = $VBoxContainer/HBoxContainer2/Radius
@onready var radius_number : Label = $VBoxContainer/HBoxContainer2/RadiusNumber

var bubble : Bubble = null

func _ready() -> void:
	Global.bubble_focused.connect(_on_bubble_focused)
	set_editable(false)

func set_editable(value : bool) -> void:
	enable.disabled = bubble == null
	drawing.disabled = not value
	opacity.editable = value
	radius.editable = value

func clear() -> void:
	enable.set_pressed_no_signal(false)
	drawing.set_pressed_no_signal(false)
	opacity.set_value_no_signal(0)
	opacity_number.text = '0.0'
	radius.set_value_no_signal(0)
	radius_number.text = '0.0'

func _on_bubble_focused(_bubble : Bubble) -> void:
	if _bubble == null or _bubble.mask_bubble == null:
		bubble = _bubble
		set_editable(false)
		clear()
		return
		
	bubble = _bubble
	
	set_editable(true)
	enable.set_pressed_no_signal(bubble.mask_bubble.enable)
	drawing.set_pressed_no_signal(bubble.mask_bubble.can_draw)
	opacity.set_value_no_signal(1 - bubble.mask_bubble.mask.color.r)
	opacity_number.text = String.num(1 - bubble.mask_bubble.mask.color.r)
	radius.set_value_no_signal(bubble.mask_bubble.mask.width)
	radius_number.text = String.num(bubble.mask_bubble.mask.width)

func _on_enable_toggled(_toggled_on: bool) -> void:
	if bubble == null:
		return
	
	if bubble.mask_bubble == null:
		bubble.add_mask()
		set_editable(true)
		drawing.set_pressed_no_signal(bubble.mask_bubble.can_draw)
		opacity.set_value_no_signal(1 - bubble.mask_bubble.mask.color.r)
		opacity_number.text = String.num(1 - bubble.mask_bubble.mask.color.r)
		radius.set_value_no_signal(bubble.mask_bubble.mask.width)
		radius_number.text = String.num(bubble.mask_bubble.mask.width)
	else:
		bubble.remove_mask()
		set_editable(false)
		clear()

func _on_drawing_toggled(toggled_on: bool) -> void:
	if bubble == null or bubble.mask_bubble == null:
		return
	
	bubble.mask_bubble.can_draw = toggled_on

func _on_opacity_value_changed(value: float) -> void:
	if bubble == null or bubble.mask_bubble == null:
		return
	
	opacity_number.text = String.num(value)
	value = 1 - value
	bubble.mask_bubble.mask.color = Color(value, value, value)

func _on_radius_value_changed(value: float) -> void:
	if bubble == null or bubble.mask_bubble == null:
		return
	
	bubble.mask_bubble.mask.width = value as int
	radius_number.text = String.num(value)

func _on_reset_pressed() -> void:
	if bubble == null or bubble.mask_bubble == null:
		return
	
	bubble.mask_bubble.mask.reset()
