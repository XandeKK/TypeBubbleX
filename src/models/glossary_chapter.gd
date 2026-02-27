class_name GlossaryChapter
extends BaseModel

var glossary_id : String = ""
var chapter_id : String = ""

func _init() -> void:
	table_name = "GlossaryChapters"
