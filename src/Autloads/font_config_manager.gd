extends Node

var dirs : Array[String] : get = get_dirs, set = set_dirs
# fonts = {
#	'fontname': {
#		'font': '',
#		'nickname': '',
#		'regular': FontVariation,
#		'bold': FontVariation,
#		'italic': FontVariation,
#		'bold-italic': FontVariation,
#	}, ...}
var fonts : Dictionary : get = get_fonts, set = set_fonts
# fonts_path = {
#	'fontname' : {
#		'regular': 'font_file_path',
#		'bold': 'font_file_path',
#		'italic': 'font_file_path',
#		'bold-italic': 'font_file_path',
#	}, ...}
var fonts_path : Dictionary : get = get_fonts_path, set = set_fonts_path

var filename : String = "user://fonts_configuration.cfg"

signal dirs_changed
signal fonts_changed

func _ready():
	load_configuration()

func save_configuration():
	var config = ConfigFile.new()
	
	config.set_value("directories", "dirs", dirs)
	config.set_value("fonts", "fonts", serialize_fonts(fonts))
	
	config.save(filename)

func load_configuration():
	var config = ConfigFile.new()
	
	var error = config.load(filename)
	
	if error == OK:
		if config.has_section_key("directories", "dirs"):
			dirs = config.get_value("directories", "dirs")
	
		scan_dirs()
		
		if config.has_section_key("fonts", "fonts"):
			fonts = deserialize_fonts(config.get_value("fonts", "fonts"))
	
		emit_signal('dirs_changed')

func serialize_fonts(_fonts : Dictionary) -> Dictionary:
	var serialized_fonts : Dictionary = {}
	for key in _fonts.keys():
		serialized_fonts[key] = {
			'font': _fonts[key]['font'],
			'nickname': _fonts[key]['nickname'],
			'regular': serialize_font(_fonts[key]['regular']),
			'bold': serialize_font(_fonts[key]['bold']),
			'italic': serialize_font(_fonts[key]['italic']),
			'bold-italic': serialize_font(_fonts[key]['bold-italic'])
		}
	return serialized_fonts

func deserialize_fonts(_fonts : Dictionary) -> Dictionary:
	var deserialized_fonts : Dictionary = {}
	for key in _fonts.keys():
		if fonts_path.has(key):
			deserialized_fonts[key] = {
				'font': key,
				'nickname': _fonts[key]['nickname'],
				'regular': deserialize_font(_fonts[key]['regular'], key, 'regular'),
				'bold': deserialize_font(_fonts[key]['bold'], key, 'bold'),
				'italic': deserialize_font(_fonts[key]['italic'], key, 'italic'),
				'bold-italic': deserialize_font(_fonts[key]['bold-italic'], key, 'bold-italic')
			}
	
	return deserialized_fonts

func serialize_font(font : FontVariation) -> Dictionary:
	if not font:
		return {}
	
	return {
		'variation_embolden': font.variation_embolden,
		'spacing_glyph': font.spacing_glyph,
		'variation_transform': font.variation_transform
	}

func deserialize_font(font : Dictionary, font_name : String, type : String) -> FontVariation:
	var font_variation : FontVariation
	
	if type == 'regular':
		font_variation = load_regular_font(font_name)
	elif fonts_path[font_name].has(type):
		font_variation = load_font(fonts_path[font_name][type])
	else:
		font_variation = load_faux_font(font_name, type)
	
	if font.is_empty():
		return font_variation
	
	font_variation.variation_embolden = font['variation_embolden']
	font_variation.variation_transform = font['variation_transform']
	font_variation.spacing_glyph = font['spacing_glyph']
	
	return font_variation

func add_dir(dir : String) -> void:
	if dirs.find(dir) != -1:
		print('already have this directory')
		return
	
	if not DirAccess.dir_exists_absolute(dir):
		print('directory does not exist')
		return
	
	dirs.append(dir)
	scan_dirs()
	emit_signal('dirs_changed')

func remove_dir(index : int) -> void:
	if index < 0 or index >= dirs.size():
		print('index out of range')
		return
	
	dirs.remove_at(index)
	scan_dirs()
	emit_signal('dirs_changed')

func scan_dirs() -> void:
	var old_fonts = fonts.duplicate()
	fonts.clear()
	fonts_path.clear()
	
	for dir in dirs:
		scan_fonts(dir)
	
	restore_fonts(old_fonts)

func scan_fonts(path : String) -> void:
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()

		while file_name != "":
			var full_path = path.path_join(file_name)

			if dir.current_is_dir():
				scan_fonts(full_path)
			elif file_name.ends_with(".otf") or file_name.ends_with(".ttf"):
				process_font_file(full_path)

			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func process_font_file(font_file_path : String) -> void:
	var font_name = font_file_path.get_file().get_basename()

	var font_style = parse_font_style(font_name)
	
	if not fonts_path.has(font_style['font']):
		fonts_path[font_style['font']] = {}
	
	fonts_path[font_style['font']][font_style['type']] = font_file_path

func parse_font_style(font : String) -> Dictionary:
	var font_lower = font.to_lower()
	var regex = RegEx.new()
	regex.compile("[\\_\\ \\-]?(reg(ular)?|bold[\\_\\ \\-]?ital(ic)?|bold|ital(ic)?)$")
	var result = regex.search(font_lower)
	
	if result:
		var type = result.get_string()
		var font_name = font.erase(result.get_start(), type.length())
		
		return { 'font': font_name, 'type': parse_font_type(type) }
	
	return { 'font': font, 'type': 'regular' }

func parse_font_type(type : String) -> String:
	if type.contains("bold") and type.contains("ital"):
		return 'bold-italic'
	elif type.contains("bold"):
		return 'bold'
	elif type.contains("ital"):
		return 'italic'
	
	return 'regular'

func restore_fonts(old_fonts : Dictionary) -> void:
	for font_key in old_fonts.keys():
		if fonts_path.has(font_key):
			add_font(font_key)
			fonts[font_key] = old_fonts[font_key]

func add_font(font : String) -> bool:
	if fonts_path.has(font):
		var font_dict : Dictionary = fonts_path[font]
		fonts[font] = {
			'font': font,
			'nickname': null,
			'regular': load_regular_font(font),
			'bold': load_font(font_dict['bold']) if font_dict.has('bold') else load_faux_font(font, 'bold'),
			'italic': load_font(font_dict['italic']) if font_dict.has('italic') else load_faux_font(font, 'italic'),
			'bold-italic': load_font(font_dict['bold-italic']) if font_dict.has('bold-italic') else load_faux_font(font, 'bold-italic'),
		}
		emit_signal('fonts_changed')
		return true
	
	print("Font not found:", font)
	return false

func remove_font(font : String) -> bool:
	if fonts.has(font):
		fonts.erase(font)
		emit_signal('fonts_changed')
		return true
	
	print("Font not found:", font)
	return false

func edit_nickname(font_name : String, nickname : String) -> void:
	if not fonts.has(font_name):
		print("Font not found:", font_name)
		return
	fonts[font_name]['nickname'] = '' if nickname.is_empty() else nickname

func edit_font(font_name : String, type : String, font_copy : FontVariation) -> void:
	if not fonts.has(font_name):
		print("Font not found:", font_name)
		return
	
	if not ["regular", "bold", "italic", "bold-italic"].has(type):
		print("Invalid font type:", type)
		return
	
	fonts[font_name][type] = font_copy.duplicate()

func load_regular_font(font : String) -> FontVariation:
	if not fonts_path.has(font):
		print("Font not found:", font)
		return load_font('')

	var font_dict : Dictionary = fonts_path[font]
	
	if font_dict.has('regular'):
		return load_font(font_dict['regular'])
	
	var type : String = font_dict.keys()[0]
	return load_font(font_dict[type])

func load_font(font_file_path : String) -> FontVariation:
	if font_file_path.is_empty():
		return FontVariation.new()
	
	var font : FontFile = FontFile.new()
	font.load_dynamic_font(font_file_path)
	var font_variation : FontVariation = FontVariation.new()
	font_variation.base_font = font
	return font_variation

func load_faux_font(font : String, type : String) -> FontVariation:
	var font_variation : FontVariation = load_regular_font(font)
	
	match type:
		'bold':
			font_variation.variation_embolden = 0.5
		'italic':
			font_variation.variation_transform = Transform2D(Vector2(1, 0.4), Vector2(0, 1), Vector2(0, 0))
		'bold-italic':
			font_variation.variation_embolden = 0.5
			font_variation.variation_transform = Transform2D(Vector2(1, 0.4), Vector2(0, 1), Vector2(0, 0))
	
	return font_variation

func get_dirs() -> Array[String]:
	return dirs

func set_dirs(value : Array[String]) -> void:
	dirs = value

func get_fonts() -> Dictionary:
	return fonts

func set_fonts(value : Dictionary) -> void:
	fonts = value

func get_fonts_path() -> Dictionary:
	return fonts_path

func set_fonts_path(value : Dictionary) -> void:
	fonts_path = value
