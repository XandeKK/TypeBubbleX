extends Control

var horizontal_alignment : HorizontalAlignment = HORIZONTAL_ALIGNMENT_CENTER : get = _get_horizontal_alignment, set = _set_horizontal_alignment
var vertical_alignment : VerticalAlignment = VERTICAL_ALIGNMENT_CENTER : get = _get_vertical_alignment, set = _set_vertical_alignment
var autowrap_mode : TextServer.AutowrapMode = TextServer.AUTOWRAP_WORD : get = _get_autowrap_mode, set = _set_autowrap_mode

var text : String = "" : get = _get_text, set = _set_text
var color : Color = Color.BLACK : get = _get_color, set = _set_color
var letter_spacing : int = 0 : get = _get_letter_spacing, set = _set_letter_spacing
var line_spacing : int = 0 : get = _get_line_spacing, set = _set_line_spacing
var font_size : int = 20 : get = _get_font_size, set = _set_font_size
var bold : bool = false : get = _get_bold, set = _set_bold
var italic : bool = false : get = _get_italic, set = _set_italic
var uppercase : bool = false : get = is_uppercase, set = _set_uppercase
var font_name : String = '' : get = _get_font_name, set = _set_font_name
var font_settings : Dictionary = {
	'regular': FontVariation.new(),
	'bold': FontVariation.new(),
	'italic': FontVariation.new(),
	'bold-italic': FontVariation.new()
} : get = _get_font_settings, set = _set_font_settings

var text_styles : TextStyles = TextStyles.new() : get = _get_text_styles, set = _set_text_styles
var gradient_text : GradientText = GradientText.new() : get = _get_gradient_text, set = _set_gradient_text

var style_box : StyleBox = StyleBoxEmpty.new() : get = _get_style_box, set = _set_style_box

var text_rid : RID = TSManager.TS.create_shaped_text()
var lines_rid : Array[RID]
var canvas_item : RID = get_canvas_item()

var glyphs_to_render : Array[Dictionary] : get = get_glyphs_to_render

@onready var shakes : Control = $Shakes
@onready var outlines : Control = $Outlines
@onready var letters : Control = $Letters

signal render
signal text_changed(value : String)

func _ready():
	text_styles.parent = self
	shakes.parent = self
	outlines.parent = self
	letters.parent = self
	
	gradient_text.letters = letters

func _prepare_glyphs_to_render() -> void:
	glyphs_to_render.clear()
	
	var rtl_layout : bool = is_layout_rtl()
	
	style_box.draw(canvas_item, Rect2(0, 0, size.x, size.y))
	
	var total_h : float = 0.0
	var lines_visible : int = 0
	
	# Get number of lines to fit to the height.
	for i in range(lines_rid.size()):
		total_h += TSManager.TS.shaped_text_get_size(lines_rid[i]).y + line_spacing
		if total_h > (get_size().y - style_box.get_minimum_size().y + line_spacing):
			break
		lines_visible += 1
	
	var last_line : int = min(lines_rid.size(), lines_visible)
	
	total_h = 0
	for i in range(last_line):
		total_h += TSManager.TS.shaped_text_get_size(lines_rid[i]).y + line_spacing
	total_h += style_box.get_margin(SIDE_TOP) + style_box.get_margin(SIDE_BOTTOM)
	
	var vbegin : int = 0
	var vsep : int = 0
	if lines_visible > 0:
		match vertical_alignment:
			VERTICAL_ALIGNMENT_TOP:
				# Nothing
				pass
			VERTICAL_ALIGNMENT_CENTER:
				vbegin = (size.y - (total_h - line_spacing)) / 2
				vsep = 0
			VERTICAL_ALIGNMENT_BOTTOM:
				vbegin = size.y - (total_h - line_spacing)
				vsep = 0
	
	var ofs : Vector2 = Vector2.ZERO
	ofs.y = style_box.get_offset().y + vbegin
	
	for i in range(last_line):
		var line_size : Vector2 = TSManager.TS.shaped_text_get_size(lines_rid[i])
		ofs.x = 0
		ofs.y += TSManager.TS.shaped_text_get_ascent(lines_rid[i])
		
		match horizontal_alignment:
			HORIZONTAL_ALIGNMENT_LEFT:
				if rtl_layout:
					ofs.x = int(size.x - style_box.get_margin(SIDE_RIGHT) - line_size.x)
				else:
					ofs.x = style_box.get_offset().x
			HORIZONTAL_ALIGNMENT_CENTER:
				ofs.x = int(size.x - line_size.x + style_box.get_margin(SIDE_LEFT) - style_box.get_margin(SIDE_RIGHT)) / 2
			HORIZONTAL_ALIGNMENT_RIGHT:
				if rtl_layout:
					ofs.x = style_box.get_offset().x
				else:
					ofs.x = int(size.x - style_box.get_margin(SIDE_RIGHT) - line_size.x)

		var glyphs : Array[Dictionary] = TSManager.TS.shaped_text_get_glyphs(lines_rid[i])
		var gl_size : int = TSManager.TS.shaped_text_get_glyph_count(lines_rid[i])
		
		# stores the glyphs to render on other objects
		for j in range(gl_size):
			for k in range(glyphs[j].repeat):
				glyphs_to_render.append({
					'glyph': glyphs[j],
					'ofs': ofs
				})
				ofs.x += glyphs[j].advance
		ofs.y += TSManager.TS.shaped_text_get_descent(lines_rid[i]) + vsep + line_spacing
	
	emit_signal('render')

func _shape() -> void:
	var width : int = size.x - style_box.get_minimum_size().x
	
	TSManager.TS.shaped_text_set_spacing(text_rid, TextServer.SPACING_GLYPH, letter_spacing)
	TSManager.TS.shaped_text_clear(text_rid)
	
	var _text : String = ''
	var text_style_current : Variant
	var text_style_normal : TextStyle = TextStyle.new()
	var _text_styles = [text_style_normal]
	
	text_style_normal.end = text.length()
	text_style_normal.bold = bold
	text_style_normal.italic = italic
	text_style_normal.font_settings = font_settings
	text_style_normal.uppercase = uppercase
	text_style_normal.font_size = font_size
	
	text_style_current = text_style_normal
	
	for i in range(text.length()):
		_text_styles += text_styles.list.filter(func(text_style): return text_style.start == i)
		
		if text_style_current != _text_styles[-1]:
			add_formatted_text(_text, text_style_current)
		
			text_style_current = _text_styles[-1]
			_text = ''
		
		_text += text[i]
		
		if i != text.length() - 1:
			_text_styles = _text_styles.filter(func(text_style): return text_style.end != i)
	
	if not _text.is_empty():
		add_formatted_text(_text, text_style_current)
		
	for i in range(lines_rid.size()):
		TSManager.TS.free_rid(lines_rid[i])
	lines_rid.clear()

	var autowrap_flags : TextServer.LineBreakFlag = TextServer.BREAK_MANDATORY
	
	match (autowrap_mode):
		TextServer.AUTOWRAP_WORD_SMART:
			autowrap_flags = TextServer.BREAK_WORD_BOUND | TextServer.BREAK_ADAPTIVE | TextServer.BREAK_MANDATORY
		TextServer.AUTOWRAP_WORD:
			autowrap_flags = TextServer.BREAK_WORD_BOUND | TextServer.BREAK_MANDATORY
		TextServer.AUTOWRAP_ARBITRARY:
			autowrap_flags = TextServer.BREAK_GRAPHEME_BOUND | TextServer.BREAK_MANDATORY
	autowrap_flags = autowrap_flags | TextServer.BREAK_TRIM_EDGE_SPACES

	var line_breaks : PackedInt32Array = TSManager.TS.shaped_text_get_line_breaks(text_rid, width, 0, autowrap_flags)
	
	for i in range(0, line_breaks.size(), 2):
		var line : RID = TSManager.TS.shaped_text_substr(text_rid, line_breaks[i], line_breaks[i + 1] - line_breaks[i])
		lines_rid.push_back(line)
	
	_prepare_glyphs_to_render()
	text_style_normal.free()

func add_formatted_text(_text, text_style):
	var _current_font : Font

	if text_style.bold and text_style.italic:
		_current_font = text_style.font_settings['bold-italic']
	elif text_style.bold:
		_current_font = text_style.font_settings['bold']
	elif text_style.italic:
		_current_font = text_style.font_settings['italic']
	else:
		_current_font = text_style.font_settings['regular']

	_text = TSManager.TS.string_to_upper(_text) if text_style.uppercase else _text
	TSManager.TS.shaped_text_add_string(text_rid, _text, _current_font.get_rids(), text_style.font_size, _current_font.get_opentype_features())


func _get_horizontal_alignment() -> HorizontalAlignment:
	return horizontal_alignment

func _set_horizontal_alignment(value : HorizontalAlignment) -> void:
	horizontal_alignment = value
	_shape()

func _get_vertical_alignment() -> VerticalAlignment:
	return vertical_alignment

func _set_vertical_alignment(value : VerticalAlignment) -> void:
	vertical_alignment = value
	_shape()

func _get_autowrap_mode() -> TextServer.AutowrapMode:
	return autowrap_mode

func _set_autowrap_mode(value : TextServer.AutowrapMode) -> void:
	autowrap_mode = value
	_shape()

func _get_text() -> String:
	return text

func _set_text(value : String) -> void:
	text = value
	_shape()
	emit_signal('text_changed', text)

func _get_color() -> Color:
	return color

func _set_color(value : Color) -> void:
	color = value
	emit_signal('render')

func _get_letter_spacing() -> int:
	return letter_spacing

func _set_letter_spacing(value : int) -> void:
	letter_spacing = value
	_shape()

func _get_line_spacing() -> int:
	return line_spacing

func _set_line_spacing(value : int) -> void:
	line_spacing = value
	_shape()

func _get_font_size() -> int:
	return font_size

func _set_font_size(value : int) -> void:
	font_size = value
	_shape()

func _get_bold() -> bool:
	return bold

func _set_bold(value : bool) -> void:
	bold = value
	_shape()

func _get_italic() -> bool:
	return italic

func _set_italic(value : bool) -> void:
	italic = value
	_shape()

func is_uppercase() -> bool:
	return uppercase

func _set_uppercase(value : bool) -> void:
	uppercase = value
	_shape()

func _get_font_name() -> String:
	return font_name

func _set_font_name(value : String) -> void:
	font_name = value

func _get_font_settings() -> Dictionary:
	return font_settings

func _set_font_settings(value : Dictionary) -> void:
	font_settings = value
	_shape()

func _get_text_styles() -> TextStyles:
	return text_styles

func _set_text_styles(value : TextStyles) -> void:
	text_styles = value
	_shape()

func _get_style_box() -> StyleBox:
	return style_box

func _set_style_box(value : StyleBox) -> void:
	style_box = value
	_shape()

func _get_gradient_text() -> GradientText:
	return gradient_text

func _set_gradient_text(value : GradientText) -> void:
	gradient_text = value

func get_glyphs_to_render() -> Array[Dictionary]:
	return glyphs_to_render

func set_content_margin(margin : Side, offset : float):
	style_box.set_content_margin(margin, offset)
	_shape()

func to_dictionary() -> Dictionary:
	return {
		'text': text,
		'color': color,
		'letter_spacing': letter_spacing,
		'line_spacing': line_spacing,
		'font_size': font_size,
		'bold': bold,
		'italic': italic,
		'uppercase': uppercase,
		'font_name': font_name,
		'text_styles': text_styles.to_dictionary(),
		'gradient_text': gradient_text.to_dictionary(),
		'content_margins': {
			SIDE_LEFT: style_box.get_margin(SIDE_LEFT),
			SIDE_TOP: style_box.get_margin(SIDE_TOP),
			SIDE_BOTTOM: style_box.get_margin(SIDE_BOTTOM),
			SIDE_RIGHT: style_box.get_margin(SIDE_RIGHT)
		},
		'shakes': shakes.to_dictionary(),
		'outlines': outlines.to_dictionary()
	}

func load(data : Dictionary) -> void:
	text = data['text']
	color = data['color']
	letter_spacing = data['letter_spacing']
	line_spacing = data['line_spacing']
	font_size = data['font_size']
	bold = data['bold']
	italic = data['italic']
	uppercase = data['uppercase']
	font_name = data['font_name']
	# I will change it to make it shareable.
	if FontConfigManager.fonts.has(font_name):
		font_settings = FontConfigManager.fonts[font_name]

	text_styles.load(data['text_styles'])
	gradient_text.load(data['gradient_text'])
	
	set_content_margin(SIDE_LEFT, data['content_margins'][SIDE_LEFT])
	set_content_margin(SIDE_TOP, data['content_margins'][SIDE_TOP])
	set_content_margin(SIDE_BOTTOM, data['content_margins'][SIDE_BOTTOM])
	set_content_margin(SIDE_RIGHT, data['content_margins'][SIDE_RIGHT])
	
	shakes.load(data['shakes'])
	outlines.load(data['outlines'])

func _exit_tree():
	text_styles.free()
	gradient_text.free()
	TSManager.TS.free_rid(text_rid)
	for i in range(lines_rid.size()):
		TSManager.TS.free_rid(lines_rid[i])
		
