extends GutTest

var Preference = load('res://src/Autloads/preference.gd')
var preference : Preference = null

func before_each():
	preference = Preference.new()
	preference.filename = 'user://test_preference_configuration.cfg'

func after_each():
	DirAccess.remove_absolute(ProjectSettings.globalize_path(preference.filename))
	preference = null

func test_save_configuration():
	preference.hq_styles = {
		preference.HQStyles.MANGA: {
			'default_font': null,
			'font_size': 20
		},
		preference.HQStyles.MANHWA: {
			'default_font': null,
			'font_size': 30
		},
		preference.HQStyles.MANHUA: {
			'default_font': null,
			'font_size': 30
		},
		preference.HQStyles.COMIC: {
			'default_font': null,
			'font_size': 25
		}
	}
	
	preference.save_configuration()
	
	var config = ConfigFile.new()
	var error = config.load(preference.filename)
	
	assert_eq(error, OK)
	assert_eq(config.get_value("hq_styles", "hq_styles"), preference.hq_styles)

func test_load_configuration():
	preference.save_configuration()
	
	preference.hq_styles[preference.HQStyles.MANGA]['font_size'] = 25
	
	preference.load_configuration()
	
	assert_eq(preference.hq_styles[preference.HQStyles.MANGA]['font_size'], 20)

func test_load_general():
	preference.general['font_size'] = 15
	
	preference.load_general()
	
	assert_eq(preference.theme.default_font_size, 15)
