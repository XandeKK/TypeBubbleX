extends Node

enum ComicType {
	MANGA,
	MANHWA,
	MANHUA,
}

var comic_type_string : Array = [
	'Manga',
	'Manhwa',
	'Manhua',
]

var default_comic : Dictionary = {
	'name': '',
	'default_font': '',
	'font_size': 20,
	'comic_type': ComicType.MANGA,
	'can_be_deleted': false,
}

var comics : Array = [
	default_comic.duplicate(),
	default_comic.duplicate(),
	default_comic.duplicate(),
]

var defaults_comics : Array = comics.duplicate(true)

var colors : Dictionary = {
	'bubble': {
		'active': Color(Color.RED, 0.7),
		'inactive': Color(Color.BLACK, 0.3),
	},
	'padding': {
		'active': Color(Color.BLUE, 0.7)
	},
	'swatches': {},
}
var default_colors : Dictionary = colors

var languages : Array = [
	'en',
	'pt_BR',
]

var general : Dictionary = {
	'language': 0,
	'font_size': 12,
	'raw_dir': 'raw',
	'cleaned_dir': 'cleaned',
	'type_bubble_x_dir': 'tbx',
	'text_filename': 'text.txt',
	'camera': {
		'min_zoom': 0.2,
		'max_zoom': 1.5,
		'zoom_rate': 0.1,
	},
}

var default_general : Dictionary = general.duplicate()

var filename : String = "user://preference_configuration.cfg"

func _ready() -> void:
	comics[0].comic_type = ComicType.MANGA
	comics[0].name = 'Manga'
	comics[1].comic_type = ComicType.MANHWA
	comics[1].name = 'Manhwa'
	comics[2].comic_type = ComicType.MANHUA
	comics[2].name = 'Manhua'
	
	load_configuration()

func save_configuration() -> void:
	var config = ConfigFile.new()
	
	config.set_value("comics", "comics", comics)
	config.set_value("colors", "colors", colors)
	config.set_value("general", "general", general)
	
	config.save(filename)

func load_configuration() -> void:
	var config : ConfigFile = ConfigFile.new()
	
	var error : Error = config.load(filename)
	
	if error == OK:
		if config.has_section_key("comics", "comics"):
			var data : Variant = config.get_value("comics", "comics")
			if typeof(data) == TYPE_ARRAY:
				comics = data
		
		if config.has_section_key("colors", "colors"):
			var data : Dictionary = config.get_value("colors", "colors")
			
			colors.bubble.merge(data.bubble, true)
			colors.padding.merge(data.padding, true)
			
			data.erase('bubble')
			data.erase('padding')
			
			colors.merge(data, true)
		
		if config.has_section_key("general", "general"):
			var data : Dictionary = config.get_value("general", "general")
			
			general.camera.merge(data.camera, true)
			
			data.erase('camera')
			
			general.merge(data, true)
			
			load_general()
 
func reset_general() -> void:
	general = default_general

func reset_comics() -> void:
	comics = defaults_comics

func load_general() -> void:
	set_locale(languages[general.language])

func set_locale(language : String) -> void:
	TranslationServer.set_locale(language)
