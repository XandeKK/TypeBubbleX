extends VBoxContainer

@onready var blur_size_input : _Input = $BlurSizeInput

var text : Text : set = set_text

func blank_all() -> void:
	text = null
	
	blur_size_input.set_editable(false)

func set_values(value : Text) -> void:
	blank_all()
	
	text = value
	
	blur_size_input.set_editable(true)

func set_text(value : Text) -> void:
	text = value
	
	if text:
		blur_size_input.set_value(text.blur_size)

func _on_blur_size_input_changed(value : int):
	text.blur_size = value
