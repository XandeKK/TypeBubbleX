extends SubViewportContainer
class_name Outline

var start : int = -1 : get = get_start, set = set_start
var end : int = -1 : get = _get_end, set = _set_end
var global : bool = true : get = get_global, set = set_global
var text : Text : set = set_text
var color : Color = Color.WHITE : get = get_color, set = set_color
var outline_size : int = 8 : get = get_outline_size, set = set_outline_size
var offset : Vector2 = Vector2.ZERO : get = get_ofs, set = set_ofs
var only_outline : bool = true : get = get_only_outline, set = set_only_outline
var blur_size : int = 0 : get = get_blur_size, set = set_blur_size

@onready var renderer : Control = $SubViewport/Renderer
@onready var blur : ColorRect = $SubViewport/Blur
@onready var gradient : GradientText = $SubViewport/Renderer/Gradient
@onready var pattern : TextureRect = $SubViewport/Renderer/Pattern

func _ready():
	renderer.outline = self

func get_start() -> int:
	return start

func set_start(value : int) -> void:
	start = value

func _get_end() -> int:
	return end

func _set_end(value : int) -> void:
	end = value

func get_global() -> bool:
	return global

func set_global(value : bool) -> void:
	global = value

func set_text(value : Text) -> void:
	text = value
	text.render.connect(renderer.queue_redraw)
	renderer.queue_redraw()

func get_color() -> Color:
	return color

func set_color(value : Color) -> void:
	color = value
	renderer.queue_redraw()

func get_outline_size() -> int:
	return outline_size

func set_outline_size(value : int) -> void:
	outline_size = value
	renderer.queue_redraw()

func get_ofs() -> Vector2:
	return offset

func set_ofs(value : Vector2) -> void:
	offset = value
	renderer.queue_redraw()

func get_only_outline() -> bool:
	return only_outline

func set_only_outline(value : bool) -> void:
	only_outline = value
	renderer.queue_redraw()

func get_blur_size() -> int:
	return blur_size

func set_blur_size(value : int) -> void:
	blur_size = value
	blur.material.set_shader_parameter('blur_size', blur_size)

func to_dictionary() -> Dictionary:
	return {
		'start': start,
		'end': end,
		'global': global,
		'color': color,
		'outline_size': outline_size,
		'offset': offset,
		'gradient': gradient.to_dictionary(),
		'pattern': pattern.to_dictionary()
	}

func load(data : Dictionary) -> void:
	color = data['color']
	outline_size = data['outline_size']
	offset = data['offset']
	
	gradient.load(data['gradient'])
	pattern.load(data['pattern'])
