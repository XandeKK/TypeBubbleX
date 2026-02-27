class_name CharacterNickname
extends BaseModel

var character_id : String = ""
var nickname : String = ""
var context : String = ""

func _init() -> void:
	table_name = "CharacterNicknames"
