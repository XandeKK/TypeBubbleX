extends PanelContainer

@onready var text_edit : TextEdit = $ScrollContainer/MarginContainer/VBoxContainer/TextEdit
@onready var text_item_list : ItemList = $ScrollContainer/MarginContainer/VBoxContainer/TextItemList

var index_text : int = -1
var scroll_text_list : VScrollBar

func _ready():
	if Global.canvas:
		connect_canvas()
	else:
		Global.canvas_setted.connect(connect_canvas)

	set_values(null)
	
	FileHandler.text_list = text_item_list
	
	scroll_text_list = text_item_list.get_v_scroll_bar()

func _unhandled_input(event):
	if event is InputEventKey and event.keycode == KEY_SPACE and event.ctrl_pressed and event.is_pressed():
		if text_item_list.item_count > 0 and index_text + 1 < text_item_list.item_count:
			if not Global.canvas.focused_bubble:
				return
			text_item_list.select(index_text + 1)
			_on_text_item_list_item_selected(index_text + 1)

func connect_canvas() -> void:
	Global.canvas.bubble_focus_changed.connect(set_values)

func blank_all():
	text_edit.text = ''
	text_edit.editable = false

func set_values(node : Control):
	if not node:
		blank_all()
		return

	text_edit.text = node.text.text
	text_edit.editable = true

func _on_text_edit_text_changed():
	Global.canvas.focused_bubble.text.text = text_edit.text

func _on_text_item_list_item_selected(index):
	index_text = index
	text_edit.text = text_item_list.get_item_text(index)
	_on_text_edit_text_changed()
	
	if index > 0:
		var scroll_by : float = text_item_list.get_item_rect(index).position.y - text_item_list.get_item_rect(index - 1).position.y
		scroll_text_list.value = scroll_by * index - scroll_by
	else:
		scroll_text_list.value = 0
