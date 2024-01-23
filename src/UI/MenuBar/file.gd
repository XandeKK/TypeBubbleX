extends PopupMenu

@export var confirmation_dialog : ConfirmationDialog
@export var font_config : Window
@export var preference : Window
@export var pattern_config : Window

var items : Array[Dictionary] = [
	{
		'keycode': KEY_O,
		'ctrl': true,
		'callable': _on_open_selected,
		'separator': false,
	},
	{
		'keycode': KEY_S,
		'ctrl': true,
		'callable': _on_save_selected,
		'separator': false,
	},
	{
		'name': '',
		'separator': true
	},
	{
		'keycode': null,
		'ctrl': false,
		'callable': _on_preference_selected,
		'separator': false,
	},
	{
		'keycode': null,
		'ctrl': false,
		'callable': _on_patternss_selected,
		'separator': false,
	},
	{
		'keycode': null,
		'ctrl': false,
		'callable': _on_fonts_selected,
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

func _on_open_selected() -> void:
	confirmation_dialog.show()

func _on_save_selected() -> void:
	FileHandler.save()

func _on_preference_selected() -> void:
	preference.show()

func _on_fonts_selected() -> void:
	font_config.show()

func _on_patternss_selected() -> void:
	pattern_config.show()

func _on_id_pressed(id):
	items[id].callable.call()
