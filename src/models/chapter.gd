extends BaseModel
class_name Chapter

var work_id : String = ""
var title : String = ""
var number : float = 0.0
var language_source : String = ""
var language_target : String = ""

func _init():
	table_name = "Chapters"

func get_characters() -> Array:
	return has_many_through(Character, "CharacterChapters", "chapter_id", "character_id")

func get_raw_pages() -> Array:
	return has_many("RawPages", RawPage, "chapter_id")

func get_clean_pages() -> Array:
	return has_many("CleanPages", CleanPage, "chapter_id")

func get_done_pages() -> Array:
	return has_many("DonePages", DonePage, "chapter_id")
