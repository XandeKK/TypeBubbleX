extends GutTest

var FontConfigManager = load('res://src/Autloads/font_config_manager.gd')
var font_config_manager : FontConfigManager = null

var deserialized_fonts : Dictionary = {
		'a': {
			'font': 'a',
			'nickname': '',
			'regular': FontVariation.new(),
			'bold': FontVariation.new(),
			'italic': FontVariation.new(),
			'bold-italic': FontVariation.new(),
		}
	}

var serialized_fonts : Dictionary = {
	'a': {
		'font': 'a',
		'nickname': '',
		'regular': {
			'variation_embolden': deserialized_fonts['a']['regular'].variation_embolden,
			'spacing_glyph': deserialized_fonts['a']['regular'].spacing_glyph,
			'variation_transform': deserialized_fonts['a']['regular'].variation_transform
		},
		'bold': {
			'variation_embolden': deserialized_fonts['a']['bold'].variation_embolden,
			'spacing_glyph': deserialized_fonts['a']['bold'].spacing_glyph,
			'variation_transform': deserialized_fonts['a']['bold'].variation_transform
		},
		'italic': {
			'variation_embolden': deserialized_fonts['a']['italic'].variation_embolden,
			'spacing_glyph': deserialized_fonts['a']['italic'].spacing_glyph,
			'variation_transform': deserialized_fonts['a']['italic'].variation_transform
		},
		'bold-italic': {
			'variation_embolden': deserialized_fonts['a']['bold-italic'].variation_embolden,
			'spacing_glyph': deserialized_fonts['a']['bold-italic'].spacing_glyph,
			'variation_transform': deserialized_fonts['a']['bold-italic'].variation_transform
		}
	}
}

func before_each():
	font_config_manager = FontConfigManager.new()

func after_each():
	font_config_manager = null

func test_serialize_fonts():
	var _serialized_fonts =  font_config_manager.serialize_fonts(deserialized_fonts)
	
	assert_eq(_serialized_fonts, serialized_fonts)

func test_serialize_font_null():
	var serialized_font = font_config_manager.serialize_font(null)
	
	assert_eq(serialized_font, {})

func test_serialize_font():
	var font : FontVariation = FontVariation.new()
	var serialized_font = font_config_manager.serialize_font(font)
	
	assert_eq(serialized_font, {
		'variation_embolden': font.variation_embolden,
		'spacing_glyph': font.spacing_glyph,
		'variation_transform': font.variation_transform
	})

func test_deserialize_fonts_empty():
	var _deserialized_fonts = font_config_manager.deserialize_fonts(serialized_fonts)
	
	# it return empty. because the font doens not exist in the fonts_path
	assert_eq(_deserialized_fonts, {})

func test_deserialize_fonts():
	font_config_manager.process_font_file('user://a-regular.ttf')
	
	var _deserialized_fonts = font_config_manager.deserialize_fonts(serialized_fonts)
	
	#assert_eq_shallow(_deserialized_fonts, deserialized_fonts)

func test_deserialize_font():
	pass
