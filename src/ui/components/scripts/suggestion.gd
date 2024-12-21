class_name Suggestion
extends Button

signal _pressed(current_text : String)

@onready var rich_text_label : RichTextLabel = $RichTextLabel

var current_text : String

func set_suggestion(suggestion : String, _text : String) -> void:
	current_text = suggestion
	rich_text_label.text = format(suggestion, _text)

func format(suggestion : String, _text : String) -> String:
	var formatted_text : String = ''
	var index : int = suggestion.to_lower().find(_text.to_lower())
	
	formatted_text = suggestion.insert(index, "[b]")
	formatted_text = formatted_text.insert(index + _text.length() + 3, "[/b]")
	
	return formatted_text

func _on_pressed() -> void:
	_pressed.emit(current_text)
