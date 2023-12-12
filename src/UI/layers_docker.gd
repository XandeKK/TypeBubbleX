extends Panel

@export var canvas : SubViewportContainer

var layers : Array[Button]
var nodes : Array[Control]

@onready var layer : Button = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/PanelContainer/ScrollContainer/Layers/Layer
@onready var layer_list : VBoxContainer = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/PanelContainer/ScrollContainer/Layers

func _ready():
	canvas.object_added.connect(add_layer)
	canvas.object_removed.connect(remove_layer)

func add_layer(node : Control) -> void:
	var _layer : Button = layer.duplicate()
	layers.append(_layer)
	nodes.append(node)
	_layer.show()
	layer_list.add_child(_layer)
	_layer.node = node
	_layer.parent = self

func remove_layer(node : Control) -> void:
	var index : int = nodes.find(node)
	var _layer = layers[index]
	layer_list.remove_child(_layer)
	layers.remove_at(index)
	nodes.remove_at(index)
	
	_layer.queue_free()

func remove_object(node : Control) -> void:
	canvas.remove_object(node)
