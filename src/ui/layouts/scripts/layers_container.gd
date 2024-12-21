extends PanelContainer

@onready var layers : VBoxContainer = $VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer
@onready var bring_forward : ButtonWithIcon = $VBoxContainer/HBoxContainer/HBoxContainer/BringForward
@onready var bring_backward : ButtonWithIcon = $VBoxContainer/HBoxContainer/HBoxContainer/BringBackward
@onready var delete : ButtonWithIcon = $VBoxContainer/HBoxContainer/Delete

var layer_scene : PackedScene = load("res://src/ui/components/scenes/layer.tscn")
var current_layer : Layer

func _ready() -> void:
	Global.bubble_focused.connect(_on_bubble_focused)
	Global.bubble_added.connect(_on_bubble_added)
	Global.bubble_removed.connect(_on_bubble_removed)
	
	bring_forward.disabled = true
	bring_backward.disabled = true
	delete.disabled = true

func _on_bubble_focused(value : Bubble) -> void:
	for layer : Layer in layers.get_children():
		if layer.bubble == value:
			layer.button.set_pressed_no_signal(true)
			current_layer = layer
		else:
			layer.button.set_pressed_no_signal(false)
	
	bring_forward.disabled = value == null
	bring_backward.disabled = value == null
	delete.disabled = value == null

func _on_current_layer_changed(value : Layer) -> void:
	current_layer = value

func _on_bubble_added(value : Bubble) -> void:
	var layer : Layer = layer_scene.instantiate()
	layer.bubble = value
	layer.focused.connect(_on_current_layer_changed)
	layers.add_child(layer)

func _on_bubble_removed(value : Bubble) -> void:
	for layer : Layer in layers.get_children():
		if layer.bubble == value:
			layer.queue_free()

func _on_check_button_toggled(toggled_on: bool) -> void:
	Global.top_canvas.raw_image.visible = toggled_on

func _on_bring_backward_pressed() -> void:
	if current_layer == null:
		return
	
	if Global.top_canvas.bring_backward(current_layer.bubble):
		Global.update_scene_hierarchy_indices()
		layers.move_child(current_layer, current_layer.bubble.scene_hierarchy_index)

func _on_bring_forward_pressed() -> void:
	if current_layer == null:
		return
	
	if Global.top_canvas.bring_forward(current_layer.bubble):
		Global.update_scene_hierarchy_indices()
		layers.move_child(current_layer, current_layer.bubble.scene_hierarchy_index)

func _on_delete_pressed() -> void:
	if current_layer == null:
		return
	
	current_layer.bubble.delete()
