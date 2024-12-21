extends PanelContainer

@onready var enable : CheckButton = $VBoxContainer/Enable
@onready var visible_status : CheckButton = $VBoxContainer/Visible

@onready var none : ButtonWithIcon = $VBoxContainer/HFlowContainer/None
@onready var add : ButtonWithIcon = $VBoxContainer/HFlowContainer/Add
@onready var remove : ButtonWithIcon = $VBoxContainer/HFlowContainer/Remove
@onready var edit : ButtonWithIcon = $VBoxContainer/HFlowContainer/Edit
@onready var manipulate : ButtonWithIcon = $VBoxContainer/HFlowContainer/Manipulate

var bubble : Bubble = null

func _ready() -> void:
	Global.bubble_focused.connect(_on_bubble_focused)
	set_editable(false)

func set_editable(value : bool) -> void:
	enable.disabled = bubble == null
	visible_status.disabled = not value
	none.disabled = not value
	add.disabled = not value
	remove.disabled = not value
	edit.disabled = not value
	manipulate.disabled = not value

func clear() -> void:
	enable.set_pressed_no_signal(false)
	visible_status.set_pressed_no_signal(false)
	none.set_pressed_no_signal(false)
	add.set_pressed_no_signal(false)
	remove.set_pressed_no_signal(false)
	edit.set_pressed_no_signal(false)
	manipulate.set_pressed_no_signal(false)

func focus_button(status : TextPath2D.STATUS) -> void:
	if bubble != null and bubble.text_path_2d != null:
		bubble.text_path_2d.current_status = status
	
	none.set_pressed_no_signal(status == TextPath2D.STATUS.NONE)
	add.set_pressed_no_signal(status == TextPath2D.STATUS.ADD)
	remove.set_pressed_no_signal(status == TextPath2D.STATUS.REMOVE)
	edit.set_pressed_no_signal(status == TextPath2D.STATUS.EDIT)
	manipulate.set_pressed_no_signal(status == TextPath2D.STATUS.MANIPULATE)

func _on_bubble_focused(_bubble : Bubble) -> void:
	if _bubble == null or _bubble.text_path_2d == null:
		bubble = _bubble
		set_editable(false)
		clear()
		return
		
	bubble = _bubble
	
	set_editable(true)
	visible_status.set_pressed_no_signal(bubble.text_path_2d.visible_status)
	enable.set_pressed_no_signal(true)
	none.button_pressed = true

func _on_enable_toggled(_toggled_on: bool) -> void:
	if bubble == null:
		return
	
	if bubble.text_path_2d == null:
		bubble.add_text_path_2d()
		set_editable(true)
		visible_status.set_pressed_no_signal(bubble.text_path_2d.visible_status)
	else:
		bubble.remove_text_path_2d()
		set_editable(false)
		clear()

func _on_show_toggled(toggled_on: bool) -> void:
	if bubble == null or bubble.text_path_2d == null:
		return
	
	bubble.text_path_2d.visible_status = toggled_on

func _on_none_toggled(toggled_on: bool) -> void:
	if toggled_on:
		focus_button(TextPath2D.STATUS.NONE)

func _on_add_toggled(toggled_on: bool) -> void:
	if toggled_on:
		focus_button(TextPath2D.STATUS.ADD)
	else:
		focus_button(TextPath2D.STATUS.NONE)

func _on_remove_toggled(toggled_on: bool) -> void:
	if toggled_on:
		focus_button(TextPath2D.STATUS.REMOVE)
	else:
		focus_button(TextPath2D.STATUS.NONE)

func _on_edit_toggled(toggled_on: bool) -> void:
	if toggled_on:
		focus_button(TextPath2D.STATUS.EDIT)
	else:
		focus_button(TextPath2D.STATUS.NONE)

func _on_manipulate_toggled(toggled_on: bool) -> void:
	if toggled_on:
		focus_button(TextPath2D.STATUS.MANIPULATE)
	else:
		focus_button(TextPath2D.STATUS.NONE)
