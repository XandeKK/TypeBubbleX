extends Node

enum ComicType {
	NULL,
	MANGA,
	MANHWA,
	MANHUA
}

var default_comic : Dictionary = {
	'default_font': null,
	'font_size': 20
}

var comics : Dictionary = {
	'manga': default_comic.duplicate(),
	'manhwa': default_comic.duplicate(),
	'manhua': default_comic.duplicate(),
	'comic_1': default_comic.duplicate(),
	'comic_2': default_comic.duplicate()
}

var defaults_comics : Dictionary = comics.duplicate()

var bubble_colors : Dictionary = {
	'bubble': {
		'active': Color(Color.RED, 0.7),
		'inactive': Color(Color.BLACK, 0.3),
	},
	'padding': {
		'active': Color(Color.BLUE, 0.7)
	}
}
var default_bubble_colors : Dictionary = bubble_colors

var languages : Array = [
	'en',
	'pt_BR'
]

var general : Dictionary = {
	'language': languages[0],
	'font_size': 12,
	'raw_dir': 'raw',
	'cleaned_dir': 'cleaned',
	'type_bubble_x_dir': 'tbx',
	'text_filename': 'text.txt',
	'camera': {
		'min_zoom': 0.2,
		'max_zoom': 1.5,
		'zoom_rate': 0.1
	}
}

var default_general : Dictionary = general.duplicate()

var filename : String = "user://preference_configuration.cfg"

func _ready() -> void:
	load_configuration()

func save_configuration() -> void:
	var config = ConfigFile.new()
	
	config.set_value("comics", "comics", comics)
	config.set_value("bubble_colors", "bubble_colors", bubble_colors)
	config.set_value("general", "general", general)
	
	config.save(filename)

func load_configuration() -> void:
	var config : ConfigFile = ConfigFile.new()
	
	var error : Error = config.load(filename)
	
	if error == OK:
		if config.has_section_key("comics", "comics"):
			comics = config.get_value("comics", "comics")
		
		if config.has_section_key("bubble_colors", "bubble_colors"):
			bubble_colors = config.get_value("bubble_colors", "bubble_colors")
		
		if config.has_section_key("general", "general"):
			general = config.get_value("general", "general")
			load_general()
 
func reset_general() -> void:
	general = default_general

func reset_comics() -> void:
	comics = defaults_comics

func load_general() -> void:
	set_locale(general.language)

func set_locale(language : String) -> void:
	TranslationServer.set_locale(language)
