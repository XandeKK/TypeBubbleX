class_name Location
extends BaseModel

var work_id : String = ""
var original_name : String = ""
var translated_name : String = ""
var description : String = ""

func _init() -> void:
	table_name = "Locations"

func get_images() -> Array:
	return has_many("LocationImages", LocationImage, "location_id")

func get_chapters() -> Array:
	return has_many("LocationChapters", LocationChapter, "location_id")
