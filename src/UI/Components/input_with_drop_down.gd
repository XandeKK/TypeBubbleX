extends LineEdit

@onready var popup : CanvasLayer = $CanvasLayer
@onready var item_list : ItemList = $CanvasLayer/ItemList

var key : String : set = _set_key
var callable_search : Callable : set = _set_callable_search
var list : Dictionary : set = _set_list

signal changed(value : String)

func _on_text_changed(new_text):
	item_list.clear()
	if new_text.is_empty():
		popup.hide()
		return

	item_list.position = Vector2(global_position.x, global_position.y + size.y)
	item_list.size = Vector2(size.x, 200)
	
	popup.show()
	new_text = new_text.to_lower()
	var callable = callable_search.bind(new_text)
	var _list = list.values().filter(callable)
	for item in _list:
		item_list.add_item(item[key])

func _on_gui_input(event):
	if event is InputEventKey and (event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER) and \
		event.is_pressed():
		if item_list.item_count == 0:
			return
		
		item_list.emit_signal('item_selected', 0)

func _on_item_list_item_selected(index):
	text = item_list.get_item_text(index)
	caret_column = text.length()
	popup.hide()
	emit_signal('changed', text)

func _set_key(value : String) -> void:
	key = value

func _set_callable_search(value : Callable) -> void:
	callable_search = value

func _set_list(value) -> void:
	list = value
