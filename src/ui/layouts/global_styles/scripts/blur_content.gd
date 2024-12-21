extends PanelContainer

@onready var enable : CheckButton = $VBoxContainer/Enable
@onready var size_box : NumberBox = $VBoxContainer/HBoxContainer/Size

var bubble : Bubble = null

func _ready() -> void:
	Global.bubble_focused.connect(_on_bubble_focused)
	set_editable(false)

func set_editable(value : bool) -> void:
	enable.disabled = bubble == null
	size_box.modifiable = value

func clear() -> void:
	enable.set_pressed_no_signal(false)
	size_box.value = 0

func _on_bubble_focused(_bubble : Bubble) -> void:
	if _bubble == null or _bubble.blur_bubble == null:
		bubble = _bubble
		set_editable(false)
		clear()
		return
		
	bubble = _bubble
	
	enable.set_pressed_no_signal(true)
	size_box.value = bubble.blur_bubble.blur_size

func _on_enable_toggled(_toggled_on: bool) -> void:
	if bubble == null:
		return
	
	if bubble.blur_bubble == null:
		bubble.add_blur()
		set_editable(true)
		size_box.value = bubble.blur_bubble.blur_size
	else:
		bubble.remove_blur()
		set_editable(false)
		clear()

func _on_size_value_changed(value: float) -> void:
	if bubble == null or bubble.blur_bubble == null:
		return
	
	bubble.blur_bubble.blur_size = value as int
