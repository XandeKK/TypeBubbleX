class_name CharacterChapter
extends BaseModel

var character_id : String = ""
var chapter_id : String = ""

func _init() -> void:
	table_name = "CharacterChapters"

func get_character() -> Character:
	return belongs_to(Character, character_id)
