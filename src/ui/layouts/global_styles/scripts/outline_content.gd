extends PanelContainer

@onready var tab_container : TabContainer = $VBoxContainer/TabContainer

var bubble : Bubble = null
var outline_scene : PackedScene = load("res://src/ui/layouts/global_styles/scenes/outline.tscn")

func _ready() -> void:
	Global.bubble_focused.connect(_on_bubble_focused)

func clear() -> void:
	for child in tab_container.get_children():
		child.queue_free()

func _on_bubble_focused(_bubble : Bubble) -> void:
	clear()
	
	bubble = _bubble
	
	if bubble == null:
		return
	
	for outline in bubble.text.outline_manager.get_outlines():
		var outline_tscn : Control = outline_scene.instantiate()
		
		$VBoxContainer/TabContainer.add_child(outline_tscn)
		
		outline_tscn.outline_manager = bubble.text.outline_manager
		outline_tscn.outline = outline

func _on_add_pressed() -> void:
	if bubble == null:
		return
	
	var outline : Outline = bubble.text.outline_manager.add()
	var outline_tscn : Control = outline_scene.instantiate()
	
	$VBoxContainer/TabContainer.add_child(outline_tscn)
	
	outline_tscn.outline_manager = bubble.text.outline_manager
	outline_tscn.outline = outline
	
