extends PanelContainer

var comic_scene : PackedScene = load("res://src/ui/windows/preferences_window/scenes/comic.tscn")

func _ready() -> void:
	var comics : Array = Preferences.comics
	var index : int = 0
	for comic : Dictionary in comics:
		add_comic(comic, index)
		index += 1

func add_comic(comic_dict : Dictionary, index : int) -> void:
	var comic : Comic = comic_scene.instantiate()
	$ScrollContainer/VBoxContainer.add_child(comic)
	
	comic.index = index
	comic.key = comic_dict.name
	comic.default_font = comic_dict.default_font
	comic.font_size = comic_dict.font_size
	comic.comic_type = comic_dict.comic_type
	comic.can_be_deleted = comic_dict.can_be_deleted

func _on_add_button_pressed() -> void:
	var comic : Dictionary = Preferences.default_comic.duplicate()
	comic.index = Preferences.comics.size()
	comic.can_be_deleted = true
	
	Preferences.comics.append(comic)
	
	add_comic(comic, comic.index)
	
