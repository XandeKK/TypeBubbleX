extends Node

enum HQTypes {
	MANGA,
	MANHWA
}

var hq_types_string : Dictionary = {
	HQTypes.MANGA: 'Manga',
	HQTypes.MANHWA: 'Manhwa'
}

var hq_types : Dictionary = {
	HQTypes.MANGA: {
		'default_font': null,
		'font_size': 20
	},
	HQTypes.MANHWA: {
		'default_font': null,
		'font_size': 20
	}
}

var colors : Dictionary = {
	'bubble': {
		'active': Color(Color.RED, 0.7),
		'inactive': Color(Color.BLACK, 0.3),
	},
	'padding': {
		'active': Color(Color.BLUE, 0.7)
	},
	'swatches': {}
}
var default_colors : Dictionary = colors

var general : Dictionary = {
	'font_size': 12,
	'raw_path': 'raw',
	'cleaned_path': 'cleaned',
	'text_filename': 'text.txt',
	'url': 'localhost',
	'port': '9876',
	'camera': {
		'min_zoom': 0.2,
		'max_zoom': 1.5,
		'zoom_rate': 0.1
	}
}

var default_general : Dictionary = general

var filename : String = "user://preference_configuration.cfg"
var theme : Theme = ResourceLoader.load('res://Assets/Themes/default_theme.tres')

func _ready() -> void:
	load_configuration()

func save_configuration() -> void:
	var config = ConfigFile.new()
	
	config.set_value("hq_types", "hq_types", hq_types)
	config.set_value("colors", "colors", colors)
	config.set_value("general", "general", general)
	
	config.save(filename)

func load_configuration() -> void:
	var config = ConfigFile.new()
	
	var error = config.load(filename)
	
	if error == OK:
		if config.has_section_key("hq_types", "hq_types"):
			hq_types = config.get_value("hq_types", "hq_types")
		
		if config.has_section_key("colors", "colors"):
			colors = config.get_value("colors", "colors")
		
		if config.has_section_key("general", "general"):
			general = config.get_value("general", "general")
			load_general()
 
func load_general() -> void:
	theme.default_font_size = general.font_size
