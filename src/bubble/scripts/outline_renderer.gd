class_name OutlineRenderer
extends Control

var outline : Outline : set = _set_outline
var text : Text : set = _set_text
var canvas_item : RID = get_canvas_item()

func _draw():
	if outline.start != -1:
		for info : Dictionary in text.glyphs_to_render:
			if info.glyph.start >= outline.start and info.glyph.start <= outline.end:
				draw_glypgh(info)
	else:
		for info : Dictionary in text.glyphs_to_render:
			draw_glypgh(info)

func draw_glypgh(info : Dictionary) -> void:
	if text.curve != null and info.has('rotation'):
		draw_glyph_on_path(info)
	else:
		draw_glyph_directly(info)


func draw_glyph_on_path(info : Dictionary) -> void:
	draw_set_transform(info.offset + outline.offset, info.rotation)
	
	if outline.fill:
		Global.TS.font_draw_glyph(info.glyph.font_rid, canvas_item, info.glyph.font_size, Vector2.ZERO, info.glyph.index, outline.color)
	
	Global.TS.font_draw_glyph_outline(info.glyph.font_rid, canvas_item,
		info.glyph.font_size, outline.outline_size, Vector2.ZERO,
		info.glyph.index, outline.color
	)

func draw_glyph_directly(info : Dictionary) -> void:
	draw_set_transform(Vector2.ZERO, 0)

	if outline.fill:
		Global.TS.font_draw_glyph(info.glyph.font_rid, canvas_item, info.glyph.font_size, info.offset + outline.offset, info.glyph.index, outline.color)
	
	Global.TS.font_draw_glyph_outline(info.glyph.font_rid, canvas_item,
		info.glyph.font_size, outline.outline_size, info.offset + outline.offset,
		info.glyph.index, outline.color
	)

func _set_outline(value : Outline) -> void:
	outline = value

func _set_text(value : Text):
	text = value
	text.render.connect(queue_redraw)
	queue_redraw()

func _on_resized() -> void:
	pass
