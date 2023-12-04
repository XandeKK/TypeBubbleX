extends Control

var start : int = -1 : get = _get_start, set = _set_start
var end : int = -1 : get = _get_end, set = _set_end
var is_global : bool = true : get = _get_is_global, set = _set_is_global
var parent : Control : set = _set_parent
var canvas_item : RID = get_canvas_item()
var color : Color = Color.WHITE : get = _get_color, set = _set_color
var outline_size : int = 8 : get = _get_outline_size, set = _set_outline_size
var offset : Vector2 = Vector2.ZERO : get = _get_ofs, set = _set_ofs

func _draw():
	print(start != -1)
	if start != -1:
		print(start)
		print(end)
		var count = 0
		for info in parent.glyphs_to_render:
			if count >= start and count <= end:
				draw_glypgh(info)
			count += 1
	else:
		for info in parent.glyphs_to_render:
			draw_glypgh(info)

func draw_glypgh(info : Dictionary):
	TSManager.TS.font_draw_glyph(info['glyph'].font_rid, canvas_item, info['glyph'].font_size, info['ofs'] + info['glyph'].offset + offset, info['glyph'].index, color)
	TSManager.TS.font_draw_glyph_outline(info['glyph'].font_rid, canvas_item, info['glyph'].font_size, outline_size, info['ofs'] + info['glyph'].offset + offset, info['glyph'].index, color)

func _get_start() -> int:
	return start

func _set_start(value : int) -> void:
	start = value

func _get_end() -> int:
	return end

func _set_end(value : int) -> void:
	end = value

func _get_is_global() -> bool:
	return is_global

func _set_is_global(value : bool) -> void:
	is_global = value

func _set_parent(value : Control) -> void:
	parent = value
	parent.render.connect(queue_redraw)
	queue_redraw()

func _get_color() -> Color:
	return color

func _set_color(value : Color) -> void:
	color = value
	queue_redraw()

func _get_outline_size() -> int:
	return outline_size

func _set_outline_size(value : int) -> void:
	outline_size = value
	queue_redraw()

func _get_ofs() -> Vector2:
	return offset

func _set_ofs(value : Vector2) -> void:
	offset = value
	queue_redraw()
