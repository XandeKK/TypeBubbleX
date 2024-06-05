extends VBoxContainer

@onready var tab_container : TabContainer = $ScrollContainer/TabContainer

@onready var add_button : Button = $HBoxContainer/AddButton
@onready var outline_item_packed : PackedScene = load("res://src/UI/Body/GlobalStyles/outline_container.tscn")

var outline_manager : OutlineManager : set = set_outline_manager

func blank_all() -> void:
	outline_manager = null
	add_button.disabled = true
	
	for child in tab_container.get_children():
		child.queue_free()

func set_values(value : OutlineManager) -> void:
	blank_all()
	
	add_button.disabled = false
	
	outline_manager = value

func repopulate() -> void:
	for outline : Outline in outline_manager.get_outlines():
		add_outline_item(outline)

func add_outline_item(outline : Outline) -> void:
	var outline_item = outline_item_packed.instantiate()
	tab_container.add_child(outline_item)
	outline_item.outline = outline
	outline_item.outline_manager = outline_manager
	outline_item.name = '0'

func set_outline_manager(value : OutlineManager) -> void:
	outline_manager = value
	if outline_manager:
		repopulate()

func _on_add_button_pressed():
	var outline = outline_manager.add()
	add_outline_item(outline)
