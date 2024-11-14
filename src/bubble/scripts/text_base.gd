class_name TextBase
extends Control

signal render
signal text_changed(value : String)

var horizontal_alignment : HorizontalAlignment = HORIZONTAL_ALIGNMENT_CENTER : get = _get_horizontal_alignment, set = _set_horizontal_alignment
var vertical_alignment : VerticalAlignment = VERTICAL_ALIGNMENT_CENTER : get = _get_vertical_alignment, set = _set_vertical_alignment
var autowrap_mode : TextServer.AutowrapMode = TextServer.AUTOWRAP_WORD : get = _get_autowrap_mode, set = _set_autowrap_mode

var text : String = "" : get = _get_text, set = _set_text
var color : Color = Color.BLACK : get = _get_color, set = _set_color
var tracking : int = 0 : get = _get_tracking, set = _set_tracking
var leading : int = 0 : get = _get_leading, set = _set_leading
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

var text_style_manager : TextStyleManager = TextStyleManager.new(self) : get = _get_text_style_manager, set = _set_text_style_manager

var style_box : StyleBox = StyleBoxEmpty.new() : get = _get_style_box, set = _set_style_box

var text_rid : RID = Global.TS.create_shaped_text()
var lines_rid : Array[RID]
var canvas_item : RID = get_canvas_item()

var glyphs_to_render : Array[Dictionary] : get = _get_glyphs_to_render
var curve : Curve2D = null : set = _set_curve2d

func _exit_tree() -> void:
	text_style_manager.free()
	Global.TS.free_rid(text_rid)
	for i in range(lines_rid.size()):
		Global.TS.free_rid(lines_rid[i])
	lines_rid.clear()

func _prepare_glyphs_to_render() -> void:
	glyphs_to_render.clear()
	
	if curve != null and curve.point_count > 0:
		_prepare_glyphs_to_render_with_path()
	else:
		_prepare_glyphs_to_render_without_path()
	
	render.emit()

func _prepare_glyphs_to_render_without_path() -> void:
	var rtl_layout : bool = is_layout_rtl()
	style_box.draw(canvas_item, Rect2(0, 0, size.x, size.y))
	
	var lines_visible : int = _calculate_visible_lines()
	var last_line : int = min(lines_rid.size(), lines_visible)
	var total_h : float = _calculate_total_height(lines_visible)
	var vbegin : int = _calculate_vertical_offset(total_h, lines_visible)
	
	var offset : Vector2 = Vector2.ZERO
	offset.y = style_box.get_offset().y + vbegin
	
	for i in range(last_line):
		var line_size : Vector2 = Global.TS.shaped_text_get_size(lines_rid[i])
		offset.x = 0
		offset.y += Global.TS.shaped_text_get_ascent(lines_rid[i])
		
		offset.x = _calculate_horizontal_offset(line_size, rtl_layout)

		var glyphs : Array[Dictionary] = Global.TS.shaped_text_get_glyphs(lines_rid[i])
		var glyph_count : int = Global.TS.shaped_text_get_glyph_count(lines_rid[i])
		
		for j in range(glyph_count):
			for k in range(glyphs[j].repeat):
				glyphs_to_render.append({
					'glyph': glyphs[j],
					'offset': offset + glyphs[j].offset
				})
				offset.x += glyphs[j].advance
		offset.y += Global.TS.shaped_text_get_descent(lines_rid[i]) + leading

func _prepare_glyphs_to_render_with_path() -> void:
	var rtl_layout : bool = is_layout_rtl()
	style_box.draw(canvas_item, Rect2(0, 0, size.x, size.y))
	
	var lines_visible : int = _calculate_visible_lines()
	var last_line : int = min(lines_rid.size(), lines_visible)
	var total_h : float = _calculate_total_height(lines_visible)
	
	var glyphs_to_render_tmp : Array
	for i in range(last_line):
		var line_size : Vector2 = Global.TS.shaped_text_get_size(lines_rid[i])
		var x : float = _calculate_horizontal_offset(line_size, rtl_layout)
		
		var glyphs : Array[Dictionary] = Global.TS.shaped_text_get_glyphs(lines_rid[i])
		var glyph_count : int = Global.TS.shaped_text_get_glyph_count(lines_rid[i])
		
		for j in range(glyph_count):
			for k in range(glyphs[j].repeat):
				if glyphs_to_render_tmp.size() == i:
					glyphs_to_render_tmp.append([])
				
				glyphs_to_render_tmp[i].append({
					'glyph': glyphs[j],
					'x': x + glyphs[j].offset.x,
					'y': glyphs[j].offset.y
				})
				x += glyphs[j].advance

	var descent : int = 0
	var vbegin : int = 0
	var y : int = 0
	
	for i in range(last_line):
		for glyphs in glyphs_to_render_tmp[i]:
			var baked : Transform2D = curve.sample_baked_with_rotation(glyphs.x)
			@warning_ignore("narrowing_conversion")
			vbegin = int(baked.get_origin().y) - int(total_h - leading) + total_h / 2
			
			@warning_ignore("narrowing_conversion")
			y = style_box.get_offset().y + vbegin
			@warning_ignore("narrowing_conversion")
			y += Global.TS.shaped_text_get_ascent(lines_rid[i]) + descent
			
			glyphs_to_render.append({
				'glyph': glyphs.glyph,
				'offset': Vector2(glyphs.x, y),
				'rotation': baked.get_rotation()
			})
		@warning_ignore("narrowing_conversion")
		descent += y + Global.TS.shaped_text_get_descent(lines_rid[i]) + leading - vbegin

func _calculate_visible_lines() -> int:
	var total_h : float = 0.0
	var lines_visible : int = 0
	
	for i in range(lines_rid.size()):
		total_h += Global.TS.shaped_text_get_size(lines_rid[i]).y + leading
		if total_h > (get_size().y - style_box.get_minimum_size().y + leading):
			break
		lines_visible += 1
	
	return lines_visible

func _calculate_total_height(lines_visible: int) -> float:
	var total_h : float = 0
	for i in range(lines_visible):
		total_h += Global.TS.shaped_text_get_size(lines_rid[i]).y + leading
	total_h += style_box.get_margin(SIDE_TOP) + style_box.get_margin(SIDE_BOTTOM)
	return total_h

func _calculate_vertical_offset(total_h: float, lines_visible: int) -> int:
	var vbegin : int = 0
	if lines_visible > 0:
		match vertical_alignment:
			VERTICAL_ALIGNMENT_CENTER:
				@warning_ignore("narrowing_conversion")
				vbegin = (size.y - (total_h - leading)) / 2
			VERTICAL_ALIGNMENT_BOTTOM:
				vbegin = int(size.y) - int(total_h - leading)
	return vbegin

func _calculate_horizontal_offset(line_size: Vector2, rtl_layout: bool) -> float:
	var x : float = 0
	match horizontal_alignment:
		HORIZONTAL_ALIGNMENT_LEFT:
			if rtl_layout:
				x = int(size.x - style_box.get_margin(SIDE_RIGHT) - line_size.x)
			else:
				x =style_box.get_offset().x
		HORIZONTAL_ALIGNMENT_CENTER:
			x = int(size.x - line_size.x + style_box.get_margin(SIDE_LEFT) - style_box.get_margin(SIDE_RIGHT)) / 2.0
		HORIZONTAL_ALIGNMENT_RIGHT:
			if rtl_layout:
				x = style_box.get_offset().x
			else:
				x = int(size.x - style_box.get_margin(SIDE_RIGHT) - line_size.x)
	return x

func _shape() -> void:
	var width : int = int(size.x) - int(style_box.get_minimum_size().x)
	
	Global.TS.shaped_text_set_spacing(text_rid, TextServer.SPACING_GLYPH, tracking)
	Global.TS.shaped_text_clear(text_rid)
	
	var _text : String = ''
	var text_style_current : Variant
	var text_style_normal : TextStyle = TextStyle.new()
	var _text_style_manager = [text_style_normal]
	
	text_style_normal.end = text.length()
	text_style_normal.bold = bold
	text_style_normal.italic = italic
	text_style_normal.font_settings = font_settings
	text_style_normal.uppercase = uppercase
	text_style_normal.font_size = font_size
	
	text_style_current = text_style_normal
	
	for i in range(text.length()):
		_text_style_manager += text_style_manager.text_styles.filter(func(text_style): return text_style.start == i)
		
		if text_style_current != _text_style_manager[-1]:
			add_formatted_text(_text, text_style_current)
		
			text_style_current = _text_style_manager[-1]
			_text = ''
		
		_text += text[i]
		
		if i != text.length() - 1:
			_text_style_manager = _text_style_manager.filter(func(text_style): return text_style.end != i)
	
	if not _text.is_empty():
		add_formatted_text(_text, text_style_current)
		
	for i in range(lines_rid.size()):
		Global.TS.free_rid(lines_rid[i])
	lines_rid.clear()

	var autowrap_flags : TextServer.LineBreakFlag = TextServer.BREAK_MANDATORY
	
	match (autowrap_mode):
		TextServer.AUTOWRAP_WORD_SMART:
			@warning_ignore("int_as_enum_without_cast", "int_as_enum_without_match")
			autowrap_flags = TextServer.BREAK_WORD_BOUND | TextServer.BREAK_ADAPTIVE | TextServer.BREAK_MANDATORY
		TextServer.AUTOWRAP_WORD:
			@warning_ignore("int_as_enum_without_cast", "int_as_enum_without_match")
			autowrap_flags = TextServer.BREAK_WORD_BOUND | TextServer.BREAK_MANDATORY
		TextServer.AUTOWRAP_ARBITRARY:
			@warning_ignore("int_as_enum_without_cast", "int_as_enum_without_match")
			autowrap_flags = TextServer.BREAK_GRAPHEME_BOUND | TextServer.BREAK_MANDATORY
	@warning_ignore("int_as_enum_without_cast")
	autowrap_flags = autowrap_flags | TextServer.BREAK_TRIM_EDGE_SPACES

	var line_breaks : PackedInt32Array = Global.TS.shaped_text_get_line_breaks(text_rid, width, 0, autowrap_flags)
	
	for i in range(0, line_breaks.size(), 2):
		var line : RID = Global.TS.shaped_text_substr(text_rid, line_breaks[i], line_breaks[i + 1] - line_breaks[i])
		lines_rid.push_back(line)
	
	_prepare_glyphs_to_render()
	text_style_normal.free()

func add_formatted_text(_text, text_style):
	var _current_font : FontVariation

	if text_style.bold and text_style.italic:
		_current_font = text_style.font_settings['bold-italic']
	elif text_style.bold:
		_current_font = text_style.font_settings['bold']
	elif text_style.italic:
		_current_font = text_style.font_settings['italic']
	else:
		_current_font = text_style.font_settings['regular']

	_text = Global.TS.string_to_upper(_text) if text_style.uppercase else _text
	Global.TS.shaped_text_add_string(text_rid, _text, _current_font.get_rids(), text_style.font_size, _current_font.get_opentype_features())

func set_content_margin(margin : Side, offset : float):
	style_box.set_content_margin(margin, offset)
	_shape()

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
	text_changed.emit(text)

func _get_color() -> Color:
	return color

func _set_color(value : Color) -> void:
	color = value
	render.emit()

func _get_tracking() -> int:
	return tracking

func _set_tracking(value : int) -> void:
	tracking = value
	_shape()

func _get_leading() -> int:
	return leading

func _set_leading(value : int) -> void:
	leading = value
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

func _get_text_style_manager() -> TextStyleManager:
	return text_style_manager

func _set_text_style_manager(value : TextStyleManager) -> void:
	text_style_manager = value
	_shape()

func _get_style_box() -> StyleBox:
	return style_box

func _set_style_box(value : StyleBox) -> void:
	style_box = value
	_shape()

func _get_glyphs_to_render() -> Array[Dictionary]:
	return glyphs_to_render

func _set_curve2d(value : Curve2D) -> void:
	curve = value
	_prepare_glyphs_to_render()
