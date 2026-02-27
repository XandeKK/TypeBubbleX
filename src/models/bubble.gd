extends BaseModel
class_name Bubble

var chapter_id : String = ""
var page_id : String = ""
var original_text : String = ""
var translated_text : String = ""
var width : float = 0.0
var height : float = 0.0
var x : float = 0.0
var y : float = 0.0
var metadata : String = ""

func _init() -> void:
	table_name = "Bubbles"
