class_name Outline
extends SubViewportContainer

@onready var sub_viewport : SubViewport = $SubViewport
@onready var outline_renderer : OutlineRenderer = $SubViewport/OutlineRenderer

var start : int = -1 : get = get_start, set = set_start
var end : int = -1 : get = _get_end, set = _set_end
var text : Text : set = _set_text
var color : Color = Color.WHITE : get = _get_color, set = _set_color
var outline_size : int = 8 : get = _get_outline_size, set = _set_outline_size
var offset : Vector2 = Vector2.ZERO : get = _get_offset, set = _set_offset
var only_outline : bool = true : get = _get_only_outline, set = _set_only_outline
var blur_outline : BlurOutline = null

func _ready() -> void:
	outline_renderer.outline = self

func add_blur() -> void:
	if blur_outline == null:
		blur_outline = Global.blur_outline_scene.instantiate()
		blur_outline.size = size
		outline_renderer.add_child(blur_outline)

func remove_blur() -> void:
	if blur_outline != null:
		outline_renderer.remove_child(blur_outline)
		blur_outline.free()

func get_start() -> int:
	return start

func set_start(value : int) -> void:
	start = value

func _get_end() -> int:
	return end

func _set_end(value : int) -> void:
	end = value

func _set_text(value : Text) -> void:
	text = value
	outline_renderer.text = text

func _get_color() -> Color:
	return color

func _set_color(value : Color) -> void:
	color = value
	outline_renderer.queue_redraw()

func _get_outline_size() -> int:
	return outline_size

func _set_outline_size(value : int) -> void:
	outline_size = value
	outline_renderer.queue_redraw()

func _get_offset() -> Vector2:
	return offset

func _set_offset(value : Vector2) -> void:
	offset = value
	outline_renderer.queue_redraw()

func _get_only_outline() -> bool:
	return only_outline

func _set_only_outline(value : bool) -> void:
	only_outline = value
	outline_renderer.queue_redraw()

func _on_resized() -> void:
	sub_viewport.size = size
	
	if outline_renderer != null:
		outline_renderer.size = size
	
	if blur_outline != null:
		blur_outline.size = size

func to_dictionary() -> Dictionary:
	var data : Dictionary = {
		'start': start,
		'end': end,
		'color': color,
		'outline_size': outline_size,
		'offset': offset,
		'only_outline': only_outline,
	}
	
	if blur_outline != null:
		data['blur'] = blur_outline.to_dictionary()
	
	return data

func load(data : Dictionary) -> void:
	start = data['start']
	end = data['end']
	color = data['color']
	outline_size = data['outline_size']
	offset = data['offset']
	only_outline = data['only_outline']
	
	if data.has('blur'):
		add_blur()
		blur_outline.load(data['blur'])
	
	outline_renderer.queue_redraw()
