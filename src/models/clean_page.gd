class_name CleanPage
extends BaseModel

var raw_page_id : String = ""
var chapter_id : String = ""
var number : int = 0

func _init() -> void:
	table_name = "CleanPages"
