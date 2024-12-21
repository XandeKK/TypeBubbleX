extends PanelContainer

@onready var enable : CheckButton = $VBoxContainer/Enable
@onready var x : NumberBox = $VBoxContainer/HBoxContainer/X
@onready var y : NumberBox = $VBoxContainer/HBoxContainer2/Y
@onready var blur_amount : NumberBox = $VBoxContainer/HBoxContainer3/BlurAmount

var bubble : Bubble = null

func _ready() -> void:
	Global.bubble_focused.connect(_on_bubble_focused)
	set_editable(false)

func set_editable(value : bool) -> void:
	enable.disabled = bubble == null
	x.modifiable = value
	y.modifiable = value
	blur_amount.modifiable = value

func clear() -> void:
	enable.set_pressed_no_signal(false)
	x.value = 0
	y.value = 0
	blur_amount.value = 0

func _on_bubble_focused(_bubble : Bubble) -> void:
	if _bubble == null or _bubble.motion_blur_bubble == null:
		bubble = _bubble
		set_editable(false)
		clear()
		return
	
	bubble = _bubble
	
	set_editable(true)
	enable.set_pressed_no_signal(true)
	x.value = bubble.motion_blur_bubble.blur_direction_x
	y.value = bubble.motion_blur_bubble.blur_direction_y
	blur_amount.value = bubble.motion_blur_bubble.blur_amount

func _on_enable_toggled(_toggled_on: bool) -> void:
	if bubble == null:
		return
	
	if bubble.motion_blur_bubble == null:
		set_editable(true)
		bubble.add_motion_blur()
		x.value = bubble.motion_blur_bubble.blur_direction_x
		y.value = bubble.motion_blur_bubble.blur_direction_y
		blur_amount.value = bubble.motion_blur_bubble.blur_amount
	else:
		bubble.remove_motion_blur()
		clear()
		set_editable(false)

func _on_x_value_changed(value: float) -> void:
	if bubble == null or bubble.motion_blur_bubble == null:
		return
	
	bubble.motion_blur_bubble.blur_direction_x = value

func _on_y_value_changed(value: float) -> void:
	if bubble == null or bubble.motion_blur_bubble == null:
		return
	
	bubble.motion_blur_bubble.blur_direction_y = value

func _on_blur_amount_value_changed(value: float) -> void:
	if bubble == null or bubble.motion_blur_bubble == null:
		return
	
	bubble.motion_blur_bubble.blur_amount = value as int
