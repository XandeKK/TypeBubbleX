class_name TextRenderer
extends Control

var gradient_text : GradientText
var pattern_text : PatternText

var text : Text : set = _set_text
var canvas_item : RID = get_canvas_item()

func _draw():
	for info : Dictionary in text.glyphs_to_render:
		var color : Color = text.color
		for text_style in text.text_style_manager.text_styles:
			if info.glyph.start >= text_style.start and info.glyph.start <= text_style.end:
				color = text_style.color

		if text.curve != null and info.has('rotation'):
			draw_glyph_on_path(info, color)
		else:
			draw_glyph_directly(info, color)

func draw_glyph_on_path(info : Dictionary, color : Color) -> void:
	draw_set_transform(info.offset, info.rotation)
	Global.TS.font_draw_glyph(info.glyph.font_rid, canvas_item, info.glyph.font_size, Vector2.ZERO, info.glyph.index, color)

func draw_glyph_directly(info : Dictionary, color : Color) -> void:
	draw_set_transform(Vector2.ZERO, 0)
	Global.TS.font_draw_glyph(info.glyph.font_rid, canvas_item, info.glyph.font_size, info.offset, info.glyph.index, color)

func _set_text(value : Text):
	text = value
	text.render.connect(queue_redraw)

func add_gradient() -> void:
	if gradient_text == null:
		gradient_text = Global.gradient_text_scene.instantiate()
		add_child(gradient_text)
		gradient_text.size = size

func remove_gradient() -> void:
	if gradient_text != null:
		remove_child(gradient_text)
		gradient_text.free()
		gradient_text = null

func add_pattern() -> void:
	if pattern_text == null:
		pattern_text = Global.pattern_text_scene.instantiate()
		add_child(pattern_text)
		pattern_text.size = size

func remove_pattern() -> void:
	if pattern_text != null:
		remove_child(pattern_text)
		pattern_text.free()
		pattern_text = null

func _on_resized() -> void:
	if gradient_text != null:
		gradient_text.size = size
	
	if pattern_text != null:
		pattern_text.size = size
