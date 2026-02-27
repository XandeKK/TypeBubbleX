class_name CharacterImage
extends BaseModel

var character_id : String = ""
var selected : bool = false

func _init() -> void:
	table_name = "CharacterImages"
