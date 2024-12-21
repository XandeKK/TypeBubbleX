extends PanelContainer

@onready var text_edit : TextEdit = $ScrollContainer/VBoxContainer/TextEdit

var bubble : Bubble

func _ready() -> void:
	Global.bubble_focused.connect(_set_values)
	set_editable(false)

func set_editable(value : bool) -> void:
	text_edit.editable = value

func clear() -> void:
	text_edit.text = ''

func _set_values(value : Bubble) -> void:
	if value == null:
		set_editable(false)
		bubble = value
		clear()
		return
	
	bubble = value
	
	set_editable(true)
	
	text_edit.text = bubble.text.text

func _on_text_edit_text_changed() -> void:
	bubble.text.text = text_edit.text
