extends Control

var parent : Control : set = set_parent
var canvas_item : RID = get_canvas_item()

func set_parent(value : Control):
	parent = value
	parent.render.connect(queue_redraw)

func _draw():
	for info in parent.glyphs_to_render:
		var _color : Color = parent.color
		for text_style in parent.text_styles.list:
			if info['glyph']['start'] >= text_style['start'] and info['glyph']['start'] <= text_style['end']:
				_color = text_style['color']
		TSManager.TS.font_draw_glyph(info['glyph'].font_rid, canvas_item, info['glyph'].font_size, info['ofs'] + info['glyph'].offset, info['glyph'].index, _color)
