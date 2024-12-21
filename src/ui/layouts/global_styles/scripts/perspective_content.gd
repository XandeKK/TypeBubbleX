extends PanelContainer

@onready var enable : CheckButton = $VBoxContainer/Enable
@onready var visible_check_button : CheckButton = $VBoxContainer/Visible

var bubble : Bubble = null

func _ready() -> void:
	Global.bubble_focused.connect(_on_bubble_focused)
	set_editable(false)

func set_editable(value : bool) -> void:
	enable.disabled = bubble == null
	visible_check_button.disabled = not value

func clear() -> void:
	enable.set_pressed_no_signal(false)
	visible_check_button.set_pressed_no_signal(false)

func _on_bubble_focused(_bubble : Bubble) -> void:
	if _bubble == null or _bubble.perspective_bubble == null:
		bubble = _bubble
		set_editable(false)
		clear()
		return
		
	bubble = _bubble
	
	set_editable(true)
	enable.set_pressed_no_signal(true)
	visible_check_button.set_pressed_no_signal(bubble.perspective_bubble.visible_status)

func _on_enable_toggled(_toggled_on: bool) -> void:
	if bubble == null:
		return
	
	if bubble.perspective_bubble == null:
		bubble.add_perspective()
		set_editable(true)
		visible_check_button.set_pressed_no_signal(bubble.perspective_bubble.visible_status)
	else:
		bubble.remove_perspective()
		set_editable(false)
		clear()

func _on_reset_pressed() -> void:
	bubble.perspective_bubble.reset()

func _on_visible_toggled(toggled_on: bool) -> void:
	bubble.perspective_bubble.visible_status = toggled_on
