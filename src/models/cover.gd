class_name Cover
extends BaseModel

var work_id : String = ""
var selected : bool = false

func _init() -> void:
	table_name = "Covers"
