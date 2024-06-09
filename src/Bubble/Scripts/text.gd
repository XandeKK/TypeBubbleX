extends TextBase
class_name Text

@onready var text_renderer : Control = $TextRenderer
@onready var outline_manager : OutlineManager = $OutlineManager
@onready var motion_blur : MotionBlur = $MotionBlur
@onready var blur : ColorRect = $Blur
@onready var gradient : GradientText = $TextRenderer/Gradient
#@onready var pattern : Pattern = $TextRenderer/Pattern

var text_path : TextPath2D
var blur_size : int = 0 : get = get_blur_size, set = set_blur_size

func _ready():
	text_renderer.text = self
	outline_manager.text = self
	text_styles.text = self

func get_blur_size() -> int:
	return blur_size

func set_blur_size(value : int) -> void:
	blur_size = value
	blur.visible = blur_size > 0
	
	blur.material.set_shader_parameter('blur_size', blur_size)

func to_dictionary() -> Dictionary:
	return {
		'text': text,
		'color': color,
		'letter_spacing': letter_spacing,
		'line_spacing': line_spacing,
		'font_size': font_size,
		'bold': bold,
		'italic': italic,
		'horizontal_alignment': horizontal_alignment,
		'uppercase': uppercase,
		'font_name': font_name,
		'text_styles': text_styles.to_dictionary(),
		'content_margins': {
			SIDE_LEFT: style_box.get_margin(SIDE_LEFT),
			SIDE_TOP: style_box.get_margin(SIDE_TOP),
			SIDE_BOTTOM: style_box.get_margin(SIDE_BOTTOM),
			SIDE_RIGHT: style_box.get_margin(SIDE_RIGHT)
		},
		'outline_manager' : outline_manager.to_dictionary(),
		'motion_blur': motion_blur.to_dictionary(),
		'gradient': gradient.to_dictionary(),
		#'pattern': pattern.to_dictionary()
	}

func load(data : Dictionary) -> void:
	text = data['text']
	color = data['color']
	letter_spacing = data['letter_spacing']
	line_spacing = data['line_spacing']
	font_size = data['font_size']
	bold = data['bold']
	italic = data['italic']
	horizontal_alignment = data['horizontal_alignment']
	uppercase = data['uppercase']
	font_name = data['font_name']
	if FontConfigManager.fonts.has(font_name):
		font_settings = FontConfigManager.fonts[font_name]

	text_styles.load(data['text_styles'])
	
	set_content_margin(SIDE_LEFT, data['content_margins'][SIDE_LEFT])
	set_content_margin(SIDE_TOP, data['content_margins'][SIDE_TOP])
	set_content_margin(SIDE_BOTTOM, data['content_margins'][SIDE_BOTTOM])
	set_content_margin(SIDE_RIGHT, data['content_margins'][SIDE_RIGHT])
	
	outline_manager.load(data['outline_manager'])
	motion_blur.load(data['motion_blur'])
	gradient.load(data['gradient'])
	#pattern.load(data['pattern'])
