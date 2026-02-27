class_name LocationChapter
extends BaseModel

var location_id : String = ""
var chapter_id : String = ""

func _init() -> void:
	table_name = "LocationChapters"
