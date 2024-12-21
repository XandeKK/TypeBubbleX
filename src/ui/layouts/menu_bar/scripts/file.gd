extends PopupMenu

@export var windows : Node
@export var file_window : Window
@export var preferences_window : Window
@export var fonts_window : Window

var items : Array[Dictionary] = [
	{
		'callable': _on_open_selected,
	},
	{
		'callable': _on_save_selected,
	},
	{
		'callable': null,
	},
	{
		'callable': _on_preference_selected,
	},
	{
		'callable': _on_fonts_selected,
	},
]

func _ready() -> void:
	windows.remove_child(file_window)
	windows.remove_child(preferences_window)
	windows.remove_child(fonts_window)

func _exit_tree() -> void:
	file_window.queue_free()
	preferences_window.queue_free()
	fonts_window.queue_free()

func _open_window(window: Window) -> void:
	if not window.get_parent():
		windows.add_child(window)
		window.show()
	else:
		window.grab_focus()

func _on_open_selected() -> void:
	_open_window(file_window)

func _on_save_selected() -> void:
	print('_on_save_selected')
	#FileHandler.save()

func _on_preference_selected() -> void:
	_open_window(preferences_window)

func _on_fonts_selected() -> void:
	_open_window(fonts_window)

func _on_id_pressed(id):
	items[id].callable.call()

func _on_file_window_close_requested() -> void:
	if file_window.get_parent():
		file_window.hide()
		windows.remove_child(file_window)

func _on_preferences_window_close_requested() -> void:
	if preferences_window.get_parent():
		preferences_window.hide()
		windows.remove_child(preferences_window)

func _on_fonts_window_close_requested() -> void:
	if fonts_window.get_parent():
		fonts_window.hide()
		windows.remove_child(fonts_window)
