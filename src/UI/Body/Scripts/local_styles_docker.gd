extends PanelContainer

var bubble : Bubble

@onready var tab_container : TabContainer = $MarginContainer/VBoxContainer/TabContainer
@onready var rich_text_label : RichTextLabel = $MarginContainer/VBoxContainer/Panel/MarginContainer/RichTextLabel

@onready var local_styles_item_packed : PackedScene = load('res://src/UI/Body/LocalStyles/local_styles_item.tscn')

func _ready():
	if Global.canvas:
		connect_canvas()
	else:
		Global.canvas_setted.connect(connect_canvas)

	set_values(null)

func connect_canvas() -> void:
	Global.canvas.bubble_focus_changed.connect(set_values)

func blank_all():
	for child in tab_container.get_children():
		child.queue_free()

func set_values(_bubble : Bubble):
	blank_all()
	
	bubble = _bubble
	
	if not bubble:
		return
	
	rich_text_label.text = bubble.text.text
	if not bubble.text.text_changed.is_connected(_on_text_changed):
		bubble.text.text_changed.connect(_on_text_changed)
	
	for text_style : TextStyle in bubble.text.text_styles.list:
		var local_styles_item = local_styles_item_packed.instantiate()
		tab_container.add_child(local_styles_item)
		local_styles_item.name = '0'
		local_styles_item.text_style = text_style

func _on_text_changed(value : String) -> void:
	rich_text_label.text = value

func _on_add_button_pressed():
	var selection_from : int = rich_text_label.get_selection_from()
	var selection_to : int = rich_text_label.get_selection_to()
	rich_text_label.deselect()
#
	if selection_from == -1 or selection_to == -1:
		return
	bubble.text.text_styles.add(selection_from, selection_to)
	
	var local_styles_item = local_styles_item_packed.instantiate()
	tab_container.add_child(local_styles_item)
	local_styles_item.name = '0'
	local_styles_item.text_style = bubble.text.text_styles.list[-1]
