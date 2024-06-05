extends Control

var outline : SubViewportContainer
var canvas_item : RID = get_canvas_item()

func _draw():
	if outline.start != -1:
		for info in outline.text.glyphs_to_render:
			if info['glyph']['start'] >= outline.start and info['glyph']['end'] - 1 <= outline.end:
				draw_glypgh(info)
	else:
		for info in outline.text.glyphs_to_render:
			draw_glypgh(info)

func draw_glypgh(info : Dictionary):
	if not outline.only_outline:
		TSManager.TS.font_draw_glyph(info['glyph'].font_rid, canvas_item, info['glyph'].font_size, info['ofs'] + info['glyph'].offset + outline.offset, info['glyph'].index, outline.color)
	TSManager.TS.font_draw_glyph_outline(info['glyph'].font_rid, canvas_item, info['glyph'].font_size, outline.outline_size, info['ofs'] + info['glyph'].offset + outline.offset, info['glyph'].index, outline.color)
