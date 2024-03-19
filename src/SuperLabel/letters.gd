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
		
		var transform_2d : Transform2D = Transform2D(0.0, Vector2(1, 1), 0.0, Vector2.ZERO)
	
		if parent.flip_x:
			transform_2d.x = Vector2(-1, 0)
		
		if parent.flip_y:
			transform_2d.y = Vector2(0, -1)
			
		TSManager.TS.font_set_transform(info['glyph'].font_rid, transform_2d)
		TSManager.TS.font_draw_glyph(info['glyph'].font_rid, canvas_item, info['glyph'].font_size, info['ofs'] + info['glyph'].offset, info['glyph'].index, _color)
