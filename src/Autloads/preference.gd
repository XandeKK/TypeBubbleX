extends Node

enum HQStyles {
	MANGA,
	MANHWA,
	MANHUA,
	COMIC
}

var hq_styles_string : Dictionary = {
	HQStyles.MANGA: 'Manga',
	HQStyles.MANHWA: 'Manhwa',
	HQStyles.MANHUA: 'Manhua',
	HQStyles.COMIC: 'Comic'
}

var hq_styles : Dictionary = {
	HQStyles.MANGA: {
		'default_font': null,
		'font_size': 20
	},
	HQStyles.MANHWA: {
		'default_font': null,
		'font_size': 20
	},
	HQStyles.MANHUA: {
		'default_font': null,
		'font_size': 20
	},
	HQStyles.COMIC: {
		'default_font': null,
		'font_size': 20
	}
}

var colors : Dictionary = {
	'text_edge': {
		'active': Color(Color.RED, 0.7),
		'deactive': Color(Color.BLACK, 0.3),
	},
	'padding': {
		'active': Color(Color.BLUE, 0.7)
	}
}

var general : Dictionary = {
	'font_size': 12,
	'language': 0
}

var filename : String = "user://preference_configuration.cfg"

var theme : Theme = ResourceLoader.load('res://Assets/Themes/main.tres')

func _ready() -> void:
	load_configuration()

func save_configuration() -> void:
	var config = ConfigFile.new()
	
	config.set_value("hq_styles", "hq_styles", hq_styles)
	config.set_value("colors", "colors", colors)
	config.set_value("general", "general", general)
	
	config.save(filename)

func load_configuration() -> void:
	var config = ConfigFile.new()
	
	var error = config.load(filename)
	
	if error == OK:
		if config.has_section_key("hq_styles", "hq_styles"):
			hq_styles = config.get_value("hq_styles", "hq_styles")
		
		if config.has_section_key("colors", "colors"):
			colors = config.get_value("colors", "colors")
		
		if config.has_section_key("general", "general"):
			general = config.get_value("general", "general")
			load_general()
 
func load_general() -> void:
	theme.default_font_size = general.font_size
	if general.has('language'):
		TranslationServer.set_locale(general.language)
	else:
		general.language = 'en'

func index_to_language(index : int) -> String:
	match index:
		0:
			return 'en'
		1:
			return 'pt_BR'
	return 'en'

func language_to_index(language : String) -> int:
	match language:
		'en':
			return 0
		'pt_BR':
			return 1
	return 0
