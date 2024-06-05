extends PopupMenu

var items : Array[Dictionary] = [
	{
		'keycode': null,
		'ctrl': true,
		'callable': _on_open_online_docs,
		'separator': false,
	},
	{
		'keycode': null,
		'ctrl': true,
		'callable': _on_save_issue_tracker,
		'separator': false,
	},
	{
		'keycode': null,
		'ctrl': false,
		'callable': _on_preference_type_bubble_ai,
		'separator': false,
	},
	{
		'keycode': null,
		'ctrl': false,
		'callable': _on_fonts_about_type_bubble_x,
		'separator': false,
	},
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

func _on_open_online_docs() -> void:
	OS.shell_open("https://github.com/XandeKK/TypeX")

func _on_save_issue_tracker() -> void:
	OS.shell_open("https://github.com/XandeKK/TypeX/issues")

func _on_preference_type_bubble_ai() -> void:
	OS.shell_open("https://github.com/XandeKK/TypeX")

func _on_fonts_about_type_bubble_x() -> void:
	Notification.message("Ainda não foi implementado")


func _on_id_pressed(id):
	items[id].callable.call()
