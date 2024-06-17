extends PanelContainer

@onready var layers : VBoxContainer = $ScrollContainer/MarginContainer/VBoxContainer/PanelContainer/ScrollContainer/LayersVBoxContainer

@onready var layer_packed : PackedScene = load('res://src/UI/Body/Layers/layer.tscn')
var selected_layer : PanelContainer

func _ready():
	Global.canvas.bubble_added.connect(on_bubble_added)
	Global.canvas.bubble_removed.connect(on_bubble_removed)

func on_bubble_added(bubble : Bubble) -> void:
	var _layer = layer_packed.instantiate()
	layers.add_child(_layer)
	_layer.bubble = bubble
	_layer.pressed.connect(on_selected)

func on_bubble_removed(_bubble : Bubble) -> void:
	for layer in layers.get_children():
		if layer.bubble == _bubble:
			if selected_layer == layer:
				selected_layer = null
			
			layer.queue_free()
			break

func on_selected(_layer : PanelContainer) -> void:
	if selected_layer == _layer:
		return
	
	if selected_layer:
		selected_layer.unselect()
	
	selected_layer = _layer
	
	selected_layer.select()

func _on_show_raw_check_button_toggled(toggled_on):
	Global.canvas.show_raw(toggled_on)
