extends Control

var start : int = -1 : get = _get_start, set = _set_start
var end : int = -1 : get = _get_end, set = _set_end
var is_global : bool = true : get = _get_is_global, set = _set_is_global

var two_direction : bool = true : get = _get_two_direction, set = _set_two_direction
var x : float = 1 : get = _get_x, set = _set_x
var y : float = 1 : get = _get_y, set = _set_y
var intensity : float = 10 : get = _get_intensity, set = _set_intensity
var quantity : int = 5 : get = _get_quantity, set = _set_quantity
var alpha : float = 0.1 : get = _get_alpha, set = _set_alpha

var parent : Control : set = _set_parent
var canvas_item : RID = get_canvas_item()

func color_and_draw(info : Dictionary, color : Color):
	var color_temp : Color
	for text_style in parent.text_styles.list:
		if info['glyph']['start'] >= text_style['start'] and info['glyph']['start'] <= text_style['end']:
			color_temp = text_style['color']
	if color_temp:
		color = color_temp
	for i in range(quantity):
		var _alpha = i / float(quantity)
		var color_shake = color
		var offset_shake = Vector2(x * intensity / i, y * intensity / i)
		
		color_shake.a = _alpha * alpha
		
		draw_glyph(info['glyph'], info['ofs'] + offset_shake, color_shake)
		if two_direction:
			offset_shake *= -1
			draw_glyph(info['glyph'], info['ofs'] + offset_shake, color_shake)

func _draw():
	var color : Color = parent.color
	if start != -1:
		var count = 0
		for info in parent.glyphs_to_render:
			if count >= start and count <= end:
				color_and_draw(info, color)
			count += 1
	else:
		for info in parent.glyphs_to_render:
			color_and_draw(info, color)


func draw_glyph(glyph : Dictionary, ofs : Vector2, color : Color):
	TSManager.TS.font_draw_glyph(glyph.font_rid, canvas_item, glyph.font_size, ofs + glyph.offset, glyph.index, color)

func _get_start() -> int:
	return start

func _set_start(value : int) -> void:
	start = value
	queue_redraw()

func _get_end() -> int:
	return end

func _set_end(value : int) -> void:
	end = value
	queue_redraw()

func _set_parent(value : Control) -> void:
	parent = value
	parent.render.connect(queue_redraw)
	queue_redraw()

func _get_is_global() -> bool:
	return is_global

func _set_is_global(value : bool) -> void:
	is_global = value
	queue_redraw()

func _get_two_direction() -> bool:
	return two_direction

func _set_two_direction(value : bool) -> void:
	two_direction = value
	queue_redraw()

func _get_x() -> float:
	return x

func _set_x(value : float) -> void:
	x = value
	queue_redraw()

func _get_y() -> float:
	return y

func _set_y(value : float) -> void:
	y = value
	queue_redraw()

func _get_intensity() -> float:
	return intensity

func _set_intensity(value : float) -> void:
	intensity = value
	queue_redraw()

func _get_quantity() -> int:
	return quantity

func _set_quantity(value : int) -> void:
	quantity = value
	queue_redraw()

func _get_alpha() -> float:
	return alpha

func _set_alpha(value : float) -> void:
	alpha = value
	queue_redraw()
