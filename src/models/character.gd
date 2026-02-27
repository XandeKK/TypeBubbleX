class_name Character
extends BaseModel

var work_id : String = ""
var original_name : String = ""
var translated_name : String = ""
var description : String = ""

func _init() -> void:
	table_name = "Characters"

func get_images() -> Array:
	return has_many("CharacterImages", CharacterImage, "character_id")

func get_nicknames() -> Array:
	return has_many("CharacterNicknames", CharacterNickname, "character_id")

func get_chapters() -> Array:
	return has_many("CharacterChapters", CharacterChapter, "character_id")
