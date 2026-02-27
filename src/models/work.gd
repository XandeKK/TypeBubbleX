extends BaseModel
class_name Work

var original_title: String = ""
var translated_title: String = ""
var description: String = ""
var type: String = ""
var status: String = ""
var author_artist: String = ""

func _init():
	table_name = "Works"

func get_covers() -> Array:
	return has_many("Covers", Cover, "work_id")

func get_chapters() -> Array:
	return has_many("Chapters", Chapter, "work_id")

func get_characters() -> Array:
	return has_many("Characters", Character, "work_id")

func get_locations() -> Array:
	return has_many("Locations", Location, "work_id")

func get_glossaries() -> Array:
	return has_many("Glossaries", Glossary, "work_id")
	
