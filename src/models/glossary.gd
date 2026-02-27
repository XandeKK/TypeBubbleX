class_name Glossary
extends BaseModel

var work_id : String = ""
var original_expression : String = ""
var translated_expression : String = ""
var examples : String = ""
var description : String = ""

func _init() -> void:
	table_name = "Glossaries"

func get_chapters() -> Array:
	return has_many("GlossaryChapters", GlossaryChapter, "glossary_id")
