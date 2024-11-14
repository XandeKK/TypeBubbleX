class_name Text
extends TextBase

@onready var text_renderer : TextRenderer = $TextRenderer
@onready var outline_manager : OutlineManager = $OutlineManager

func _ready() -> void:
	text_renderer.text = self
	outline_manager.text = self

func _on_resized() -> void:
	text_renderer.size = size
	outline_manager.size = size

func to_dictionary() -> Dictionary:
	var data = {
		'text': text,
		'color': color,
		'tracking': tracking,
		'leading': leading,
		'font_size': font_size,
		'bold': bold,
		'italic': italic,
		'horizontal_alignment': horizontal_alignment,
		'vertical_alignment': vertical_alignment,
		'autowrap_mode': autowrap_mode,
		'uppercase': uppercase,
		'font_name': font_name,
		'text_style_manager': text_style_manager.to_dictionary(),
		'content_margins': {
			SIDE_LEFT: style_box.get_margin(SIDE_LEFT),
			SIDE_TOP: style_box.get_margin(SIDE_TOP),
			SIDE_BOTTOM: style_box.get_margin(SIDE_BOTTOM),
			SIDE_RIGHT: style_box.get_margin(SIDE_RIGHT)
		},
		'outline_manager': outline_manager.to_dictionary(),
	}
	
	return data

func load(data : Dictionary) -> void:
	text = data['text']
	color = data['color']
	tracking = data['tracking']
	leading = data['leading']
	font_size = data['font_size']
	bold = data['bold']
	italic = data['italic']
	horizontal_alignment = data['horizontal_alignment']
	vertical_alignment = data['vertical_alignment']
	autowrap_mode = data['autowrap_mode']
	uppercase = data['uppercase']
	font_name = data['font_name']
	if FontConfigManager.fonts.has(font_name):
		font_settings = FontConfigManager.fonts[font_name]

	text_style_manager.load(data['text_style_manager'])
	outline_manager.load(data['outline_manager'])
	
	set_content_margin(SIDE_LEFT, data['content_margins'][SIDE_LEFT])
	set_content_margin(SIDE_TOP, data['content_margins'][SIDE_TOP])
	set_content_margin(SIDE_BOTTOM, data['content_margins'][SIDE_BOTTOM])
	set_content_margin(SIDE_RIGHT, data['content_margins'][SIDE_RIGHT])
