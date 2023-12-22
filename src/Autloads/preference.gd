extends Node

enum Styles {
	MANGA,
	MANHWA,
	MANHUA,
	COMIC
}

var styles_string : Dictionary = {
	Styles.MANGA: 'Manga',
	Styles.MANHWA: 'Manhwa',
	Styles.MANHUA: 'Manhua',
	Styles.COMIC: 'Comic'
}

var styles : Dictionary = {
	Styles.MANGA: {
		'default_font': null,
		'font_size': 20
	},
	Styles.MANHWA: {
		'default_font': null,
		'font_size': 20
	},
	Styles.MANHUA: {
		'default_font': null,
		'font_size': 20
	},
	Styles.COMIC: {
		'default_font': null,
		'font_size': 20
	}
}

var colors : Dictionary = {
	'text_edge': {
		'active': Color.RED,
		'disabled': Color(Color.RED, 0.3),
	},
	'rect_rotation': {
		'active': Color.RED
	},
	'padding': {
		'active': Color.BLUE
	}
}

var general : Dictionary = {
	'font_size': 12
}

var filename : String = "user://preference_configuration.cfg"

var theme : Theme = ResourceLoader.load('res://Assets/Themes/main.tres')

func _ready():
	load_configuration()

func save_configuration():
	var config = ConfigFile.new()
	
	config.set_value("styles", "styles", styles)
	config.set_value("colors", "colors", colors)
	config.set_value("general", "general", general)
	
	config.save(filename)

func load_configuration():
	var config = ConfigFile.new()
	
	var error = config.load(filename)
	
	if error == OK:
		if config.has_section_key("styles", "styles"):
			styles = config.get_value("styles", "styles")
		
		if config.has_section_key("colors", "colors"):
			colors = config.get_value("colors", "colors")
		
		if config.has_section_key("general", "general"):
			general = config.get_value("general", "general")
			load_general()
 
func load_general() -> void:
	theme.default_font_size = general.font_size
