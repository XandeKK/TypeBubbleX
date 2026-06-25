extends Node

const SAVE_PATH = "user://preferences.tres"

var data: UserPreferences

func _ready() -> void:
	load_preferences()

func load_preferences() -> void:
	if ResourceLoader.exists(SAVE_PATH):
		data = ResourceLoader.load(SAVE_PATH)
	
	if not data:
		data = UserPreferences.new()

func save_preferences() -> void:
	ResourceSaver.save(data, SAVE_PATH)
