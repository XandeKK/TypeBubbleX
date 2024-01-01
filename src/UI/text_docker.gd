extends Panel

@export var canvas : SubViewportContainer

@onready var text : TextEdit = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/TextEdit
@onready var text_list : ItemList = $MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/TextList

var index_text : int = -1
var scroll_text_list : VScrollBar

func _ready():
	canvas.object_focus_changed.connect(set_values)
	set_values(null)
	connect_all()
	
	FileHandler.text_list = text_list
	
	scroll_text_list = text_list.get_v_scroll_bar()

func _unhandled_input(event):
	if event is InputEventKey and event.keycode == KEY_SPACE and event.ctrl_pressed and event.is_pressed():
		if text_list.item_count > 0 and index_text + 1 < text_list.item_count:
			if not canvas.focused_object:
				return
			text_list.select(index_text + 1)
			_on_text_list_item_selected(index_text + 1)

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
	if not canvas.focused_object:
		return

	index_text = index
	text.text = text_list.get_item_text(index)
	set_text()
	
	if index > 0:
		var scroll_by : float = text_list.get_item_rect(index).position.y - text_list.get_item_rect(index - 1).position.y
		scroll_text_list.value = scroll_by * index - scroll_by
	else:
		scroll_text_list.value = 0
