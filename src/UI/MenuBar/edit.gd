extends PopupMenu

@export var canvas : SubViewportContainer

var items : Array[Dictionary] = [
	{
		'keycode': null,
		'ctrl': false,
		'callable': _on_clear_selected,
		'separator': false,
	}
]

func _ready():
	var count = 0 
	
	for item in items:
		if not item.has('keycode'):
			continue
		
		if item.keycode:
			var shortcut : Shortcut = Shortcut.new()
			var shortcutKeyEvent : InputEventKey = InputEventKey.new()
			shortcutKeyEvent.keycode = item.keycode
			shortcutKeyEvent.command_or_control_autoremap = item.ctrl
			shortcut.events.append(shortcutKeyEvent)
			set_item_shortcut(count, shortcut, true)
		
		count+= 1

func _on_clear_selected():
	canvas.clear_texts()

func _on_id_pressed(id):
	items[id].callable.call()
