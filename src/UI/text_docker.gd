extends Panel

@export var canvas : SubViewportContainer

@onready var text : TextEdit = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/TextEdit
@onready var text_list : ItemList = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/TextList

func _ready():
	canvas.object_focus_changed.connect(set_values)
	set_values(null)
	connect_all()

func connect_all():
	text.text_changed.connect(set_text)

func blank_all():
	text.text = ''

func set_values(node : Control):
	if not node:
		blank_all()
		return

	text.text = str(node.text.text)

func set_text() -> void:
	if not canvas.focused_object:
		return

	canvas.focused_object.text.text = text.text

func _on_text_list_item_selected(index):
	text.text = text_list.get_item_text(index)
	set_text()
