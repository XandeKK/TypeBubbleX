class_name MenuItemConfig
extends Resource

var text : String
var callback : Callable
var shortcut : Shortcut
var id : int

func _init(_text : String, _callback : Callable, shortcut_text : String = "") -> void:
	text = _text
	callback = _callback
	
	if not shortcut_text.is_empty():
		shortcut = _create_shortcut_from_string(shortcut_text)

func _create_shortcut_from_string(text_key : String) -> Shortcut:
	var input_event : InputEventKey = InputEventKey.new()
	var parts : PackedStringArray = text_key.to_lower().strip_edges().split("+")
	
	for part : String in parts:
		match part:
			"ctrl", "control":
				input_event.ctrl_pressed = true
			"shift":
				input_event.shift_pressed = true
			"alt":
				input_event.alt_pressed = true
			"meta", "command", "win":
				input_event.meta_pressed = true
			_:
				var keycode : Key = OS.find_keycode_from_string(part)
				if keycode != KEY_NONE:
					input_event.keycode = keycode
				else:
					printerr("Error: Invalid key found in shortcut: ", part)
					return null
	
	var new_shortcut : Shortcut = Shortcut.new()
	new_shortcut.events.append(input_event)
	return new_shortcut
