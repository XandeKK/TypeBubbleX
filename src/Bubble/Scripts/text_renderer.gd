extends Control

var text : Text : set = set_text
var canvas_item : RID = get_canvas_item()

func set_text(value : Text):
	text = value
	text.render.connect(queue_redraw)

func _draw():
	for info in text.glyphs_to_render:
		var _color : Color = text.color
		for text_style in text.text_styles.list:
			if info['glyph']['start'] >= text_style['start'] and info['glyph']['start'] <= text_style['end']:
				_color = text_style['color']

		if text.text_path.active:
			draw_glyph_on_path(info, _color)
		else:
			draw_glyph_directly(info, _color)

func draw_glyph_on_path(info: Dictionary, _color : Color) -> void:
	var baked : Transform2D = text.text_path.curve.sample_baked_with_rotation(text.text_path.curve.get_closest_offset(info['ofs'] + info['glyph'].offset))
	var _rotation = baked.get_rotation() - deg_to_rad(90)
	var closet_point : Vector2 = text.text_path.curve.get_closest_point(info['ofs'] + info['glyph'].offset)
	var distance : Vector2 = text.text_path.curve_original.get_closest_point(info['ofs'] + info['glyph'].offset) - info['ofs'] + info['glyph'].offset
	var _position : Vector2 = closet_point - distance
	
	draw_set_transform(Vector2(_position.x  + info['glyph'].font_size / 2, _position.y + info['glyph'].font_size / 2), _rotation)
	
	TSManager.TS.font_draw_glyph(info['glyph'].font_rid, canvas_item, info['glyph'].font_size, Vector2(-info['glyph'].font_size / 2, -info['glyph'].font_size / 2), info['glyph'].index, _color)

func draw_glyph_directly(info : Dictionary, _color : Color) -> void:
	draw_set_transform(Vector2.ZERO, 0)
	TSManager.TS.font_draw_glyph(info['glyph'].font_rid, canvas_item, info['glyph'].font_size, info['ofs'] + info['glyph'].offset, info['glyph'].index, _color)
