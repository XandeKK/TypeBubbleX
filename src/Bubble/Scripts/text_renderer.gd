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

		# Para colcoar flip_x e flip_y, tente modificar o transform para aplicá-los
		TSManager.TS.font_draw_glyph(info['glyph'].font_rid, canvas_item, info['glyph'].font_size, info['ofs'] + info['glyph'].offset, info['glyph'].index, _color)
