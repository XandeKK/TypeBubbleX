extends PopupMenu

@export var confirmation_dialog : ConfirmationDialog

var items : Array[Dictionary] = [
	{
		'name': 'Open',
		'keycode': KEY_O,
		'ctrl': true,
		'callable': _on_open_selected,
		'separator': false,
	},
	{
		'name': 'Save',
		'keycode': KEY_S,
		'ctrl': true,
		'callable': _on_save_selected,
		'separator': false,
	}
]

func _ready():
	var count = 0 
	for item in items:
		if item.separator:
			add_separator(item.name)
		else:
			add_item(item.name, count)
			
			var shortcut : Shortcut = Shortcut.new()
			var shortcutKeyEvent : InputEventKey = InputEventKey.new()
			shortcutKeyEvent.keycode = item.keycode
			shortcutKeyEvent.command_or_control_autoremap = item.ctrl
			shortcut.events.append(shortcutKeyEvent)
			set_item_shortcut(count, shortcut, true)
		
		count+= 1

func _on_open_selected():
	confirmation_dialog.show()

func _on_save_selected():
	FileHandler.save()
	print("Save selected")

func _on_id_pressed(id):
	items[id].callable.call()
