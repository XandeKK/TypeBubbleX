extends Control

var outline : Outline
var canvas_item : RID = get_canvas_item()

func _draw():
	if outline.start != -1:
		for info in outline.text.glyphs_to_render:
			if info['glyph']['start'] >= outline.start and info['glyph']['end'] - 1 <= outline.end:
				draw_glypgh(info)
	else:
		for info in outline.text.glyphs_to_render:
			draw_glypgh(info)

func draw_glypgh(info : Dictionary) -> void:
	if outline.text.text_path.active:
		draw_glyph_on_path(info)
	else:
		draw_glyph_directly(info)

func draw_glyph_on_path(info: Dictionary) -> void:
	var pos : Vector2 = info['ofs'] + info['glyph'].offset + outline.offset
	var baked : Transform2D = outline.text.text_path.curve.sample_baked_with_rotation(outline.text.text_path.curve.get_closest_offset(pos))
	var _rotation = baked.get_rotation() - deg_to_rad(90)
	var closet_point : Vector2 = outline.text.text_path.curve.get_closest_point(pos)
	var distance : Vector2 = outline.text.text_path.curve_original.get_closest_point(pos) - pos
	var _position : Vector2 = closet_point - distance
	
	draw_set_transform(Vector2(_position.x  + info['glyph'].font_size / 2, _position.y + info['glyph'].font_size / 2), _rotation)
	
	if not outline.only_outline:
		TSManager.TS.font_draw_glyph(info['glyph'].font_rid, canvas_item, info['glyph'].font_size, Vector2(-info['glyph'].font_size / 2, -info['glyph'].font_size / 2), info['glyph'].index, outline.color)
	TSManager.TS.font_draw_glyph_outline(info['glyph'].font_rid, canvas_item, info['glyph'].font_size, outline.outline_size, Vector2(-info['glyph'].font_size / 2, -info['glyph'].font_size / 2), info['glyph'].index, outline.color)

func draw_glyph_directly(info : Dictionary) -> void:
	draw_set_transform(Vector2.ZERO, 0)
	if not outline.only_outline:
		TSManager.TS.font_draw_glyph(info['glyph'].font_rid, canvas_item, info['glyph'].font_size, info['ofs'] + info['glyph'].offset + outline.offset, info['glyph'].index, outline.color)
	TSManager.TS.font_draw_glyph_outline(info['glyph'].font_rid, canvas_item, info['glyph'].font_size, outline.outline_size, info['ofs'] + info['glyph'].offset + outline.offset, info['glyph'].index, outline.color)
