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

var lights : Lights = Lights.new() : get = _get_lights, set = _set_lights
var patterns : Patterns = Patterns.new() : get = _get_patterns, set = _set_patterns
var text_styles : TextStyles = TextStyles.new() : get = _get_text_styles, set = _set_text_styles

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
	
	lights.parent = letters
	patterns.parent = letters

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
	
	# add curve2d
	# How are you going to put curve2d?
	# well, put two variables here, t and dt, so if it is activated, it will put xform in
	# glyphs_to_render instead of ofs
	
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
	for i in range(text.length()):
		var _bold : bool = bold
		var _italic : bool = italic
		var _font_size : int = font_size
		var _uppercase : bool = uppercase
		var _font_settings : Dictionary = font_settings
		var _current_font : Font
	
		for text_style in text_styles.list:
			if i >= text_style.start and i <= text_style.end:
				_bold = text_style.bold
				_italic = text_style.italic
				_font_settings = text_style.font_settings
				_uppercase = text_style.uppercase
				_font_size = text_style.font_size
			
		if _bold and _italic:
			_current_font = _font_settings['bold-italic']
		elif _bold:
			_current_font = _font_settings['bold']
		elif _italic:
			_current_font = _font_settings['italic']
		else:
			_current_font = _font_settings['regular']
			
		assert(_current_font != null, 'Does not have the font.')
		
		var txt : String = TSManager.TS.string_to_upper(text[i]) if _uppercase else text[i]
		TSManager.TS.shaped_text_add_string(text_rid, txt, _current_font.get_rids(), _font_size, _current_font.get_opentype_features())
	
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

func _get_lights() -> Lights:
	return lights

func _set_lights(value : Lights) -> void:
	lights = value

func _get_patterns() -> Patterns:
	return patterns

func _set_patterns(value : Patterns) -> void:
	patterns = value

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
		#'lights': lights.to_dictionary(),
		#'patterns': patterns.to_dictionary(),
		'text_styles': text_styles.to_dictionary(),
		'content_margins': {
			SIDE_LEFT: style_box.get_margin(SIDE_LEFT),
			SIDE_TOP: style_box.get_margin(SIDE_TOP),
			SIDE_BOTTOM: style_box.get_margin(SIDE_BOTTOM),
			SIDE_RIGHT: style_box.get_margin(SIDE_RIGHT)
		},
		'shakes': shakes.to_dictionary(),
		'outlines': outlines.to_dictionary()
	}
