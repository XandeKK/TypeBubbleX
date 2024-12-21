class_name Layer
extends PanelContainer

signal focused(layer : Layer)

@onready var button : Button = $Button
@onready var label : Label = $Button/MarginContainer/HBoxContainer/Label

var bubble : Bubble : set = _set_bubble

func _set_bubble(value : Bubble) -> void:
	bubble = value
	bubble.text.text_changed.connect(_on_text_changed)

func _on_text_changed(value : String) -> void:
	label.text = value.strip_escapes()

func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		bubble.set_focus(true)
		Global.top_canvas.camera2d.position = bubble.global_position + bubble.size / 2
		focused.emit(self)
	else:
		bubble.set_focus(false)
		Global.set_focused_bubble(null)
		Global.update_scene_hierarchy_indices()
		focused.emit(null)
