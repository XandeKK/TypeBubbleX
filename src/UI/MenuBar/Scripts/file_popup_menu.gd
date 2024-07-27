extends PopupMenu

@onready var file_window : PackedScene = load("res://src/UI/MenuBar/file_window.tscn")
@onready var preference_window : PackedScene = load("res://src/UI/MenuBar/preference_window.tscn")
@onready var fonts_window : PackedScene = load("res://src/UI/MenuBar/fonts_window.tscn")
#@export var file_window : ConfirmationDialog
#@export var preference_window : Window
#@export var fonts_window : Window

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
	var window : ConfirmationDialog = file_window.instantiate()
	get_tree().root.add_child(window)
	window.show()

func _on_save_selected() -> void:
	FileHandler.save()

func _on_preference_selected() -> void:
	var window : Window = preference_window.instantiate()
	get_tree().root.add_child(window)
	window.show()

func _on_fonts_selected() -> void:
	var window : Window = fonts_window.instantiate()
	get_tree().root.add_child(window)
	window.show()

func _on_id_pressed(id):
	items[id].callable.call()
