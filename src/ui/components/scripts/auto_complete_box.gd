class_name AutoCompleteBox
extends LineEdit

signal value_changed(new_text : String)

@onready var pop_up : PanelContainer = $CanvasLayer/PopUp
@onready var suggestions : VBoxContainer = $CanvasLayer/PopUp/ScrollContainer/Suggestions

var callable_search : Callable = default_search
var suggestions_array : Array
var suggestions_dict : Dictionary

var suggestion_scene : PackedScene = load("res://src/ui/components/scenes/suggestion.tscn")

func default_search(_text : String, new_text : String) -> bool:
	return _text.to_lower().contains(new_text.to_lower())

func set_value(new_text : String) -> void:
	clear_suggestions()
	
	text = new_text
	caret_column = text.length()
	grab_focus()
	pop_up.hide()
	
	value_changed.emit(new_text)

func clear_suggestions() -> void:
	for child in suggestions.get_children():
		child.queue_free()

func _on_text_changed(new_text: String) -> void:
	clear_suggestions()
	
	if new_text.is_empty():
		pop_up.hide()
		return
	
	pop_up.global_position = Vector2(global_position.x, global_position.y + size.y)
	pop_up.size.x = size.x
	pop_up.show()
	
	var result : Array = suggestions_array.filter(callable_search.bind(new_text))
	var dict_results : Array = suggestions_dict.keys().filter(callable_search.bind(new_text))
	
	result.append_array(dict_results)
	
	for item in result:
		var suggestion : Suggestion = suggestion_scene.instantiate()
		suggestions.add_child(suggestion)
		suggestion.set_suggestion(item, new_text)
		suggestion._pressed.connect(set_value)

func _on_text_submitted(_new_text: String) -> void:
	if suggestions.get_child_count() == 0:
		return
	
	set_value(suggestions.get_child(0).current_text)

func _on_focus_exited() -> void:
	await get_tree().create_timer(0.1).timeout
	pop_up.hide()
