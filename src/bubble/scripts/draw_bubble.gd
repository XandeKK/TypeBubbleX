class_name DrawBubble
extends Control

var bubble : Bubble
var can_draw : bool = true

func _init(_bubble : Bubble) -> void:
	bubble = _bubble
	bubble.add_child(self)
	bubble.resized.connect(_on_resized)

func _draw():
	if not can_draw:
		return
	
	if bubble.is_focused:
		draw_focused_elements()
	else:
		draw_inactive_text_rect()

func _on_resized() -> void:
	size = bubble.size

func draw_focused_elements():
	var left = bubble.text.style_box.get_margin(SIDE_LEFT)
	var right = bubble.text.style_box.get_margin(SIDE_RIGHT)
	var top = bubble.text.style_box.get_margin(SIDE_TOP)
	var bottom = bubble.text.style_box.get_margin(SIDE_BOTTOM)
	
	# Draw content margin rect
	var content_rect = Rect2(Vector2(left, top), size - Vector2(right, bottom))
	draw_polyline(create_packed_vector(content_rect), Preferences.bubble_colors.padding.active, 1, true)
	
	# Draw text rect
	var text_rect = Rect2(Vector2.ZERO, size)
	draw_polyline(create_packed_vector(text_rect), Preferences.bubble_colors.bubble.active, 1, true)

func draw_inactive_text_rect():
	var text_rect = Rect2(Vector2.ZERO, size)
	draw_polyline(create_packed_vector(text_rect), Preferences.bubble_colors.bubble.inactive, 1, true)

func create_packed_vector(rect : Rect2) -> PackedVector2Array:
	return PackedVector2Array([
		Vector2(rect.position),
		Vector2(rect.size.x, rect.position.y),
		Vector2(rect.size.x, rect.size.y),
		Vector2(rect.position.x, rect.size.y),
		Vector2(rect.position),
	])
