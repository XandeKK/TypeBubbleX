class_name RawPage
extends BaseModel

var chapter_id : String = ""
var number : int = 0

func _init() -> void:
	table_name = "RawPages"

func get_clean_pages() -> Array:
	return has_many("CleanPages", CleanPage, "raw_page_id")

func get_done_pages() -> Array:
	return has_many("DonePages", DonePage, "raw_page_id")
