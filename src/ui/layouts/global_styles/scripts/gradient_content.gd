extends PanelContainer

@onready var enable : CheckButton = $VBoxContainer/Enable
@onready var gradient_editor : GradientEditor = $VBoxContainer/GradientEditor

var bubble : Bubble = null

func _ready() -> void:
	Global.bubble_focused.connect(_on_bubble_focused)
	set_editable(false)

func set_editable(value : bool) -> void:
	enable.disabled = bubble == null
	
	if gradient_editor == null:
		return
	
	gradient_editor.editable = value

func clear() -> void:
	gradient_editor.clear()
	enable.set_pressed_no_signal(false)

func _on_bubble_focused(_bubble : Bubble) -> void:
	if _bubble == null or _bubble.text.text_renderer.gradient_text == null:
		bubble = _bubble
		set_editable(false)
		clear()
		return
		
	bubble = _bubble
	
	set_editable(true)
	enable.set_pressed_no_signal(true)
	gradient_editor.gradient_texture_2d = bubble.text.text_renderer.gradient_text.get_gradient_texture_2d()

func _on_enable_toggled(_toggled_on: bool) -> void:
	if bubble == null:
		return
	
	if bubble.text.text_renderer.gradient_text == null:
		bubble.text.text_renderer.add_gradient()
		set_editable(true)
		gradient_editor.gradient_texture_2d = bubble.text.text_renderer.gradient_text.get_gradient_texture_2d()
	else:
		bubble.text.text_renderer.remove_gradient()
		set_editable(false)
		clear()
