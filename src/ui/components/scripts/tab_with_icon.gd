@tool
class_name TabWithIcon
extends Button

@export var content : Control
@export var image : Texture2D : set = _set_image
@export var margin : int = 4 : set = _set_margin

@onready var margin_container : MarginContainer = $MarginContainer
@onready var icon_texture : TextureRect = $MarginContainer/Icon

func _ready() -> void:
	if image != null:
		icon_texture.texture = image
	
	set_all_margin()

func _draw() -> void:
	if icon_texture == null:
		return

	var draw_mode : DrawMode = get_draw_mode()
	
	match draw_mode:
		DrawMode.DRAW_NORMAL:
			icon_texture.modulate = get_theme_color('icon_normal_color')
		DrawMode.DRAW_HOVER_PRESSED:
			icon_texture.modulate = get_theme_color('icon_hover_pressed_color')
		DrawMode.DRAW_PRESSED:
			icon_texture.modulate = get_theme_color('icon_pressed_color')
		DrawMode.DRAW_HOVER:
			icon_texture.modulate = get_theme_color('icon_hover_color')
		DrawMode.DRAW_DISABLED:
			icon_texture.modulate = get_theme_color('icon_disabled_color')

func set_all_margin() -> void:
	margin_container.add_theme_constant_override('margin_left', margin)
	margin_container.add_theme_constant_override('margin_top', margin)
	margin_container.add_theme_constant_override('margin_bottom', margin)
	margin_container.add_theme_constant_override('margin_right', margin)

func _set_image(value : Texture2D) -> void:
	image = value
	if icon_texture != null:
		icon_texture.texture = image

func _set_margin(value : int) -> void:
	margin = value
	if margin_container != null:
		set_all_margin()

func _on_toggled(toggled_on: bool) -> void:
	if content == null or not toggled_on:
		return
	
	content.visible = toggled_on
	
	for tab : Button in get_tree().get_nodes_in_group('global_styles'):
		if tab == self:
			continue
		tab.content.hide()
		tab.set_pressed_no_signal(false)
