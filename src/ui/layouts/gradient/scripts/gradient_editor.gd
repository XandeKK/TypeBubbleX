class_name GradientEditor
extends VBoxContainer

@onready var fill : OptionButton = $HBoxContainer/Fill
@onready var repeat : OptionButton = $HBoxContainer2/Repeat
@onready var interpolation : OptionButton = $HBoxContainer3/Interpoletaion
@onready var color_space : OptionButton = $HBoxContainer4/ColorSpace
@onready var gradient_1d_editor : Gradient1DEditor = $Gradient1DEditor
@onready var gradient_2d_editor : Gradient2DEditor = $HBoxContainer5/Gradient2DEditor

var gradient_texture_2d : GradientTexture2D : set = _set_gradient_texture_2d
var editable : bool = true : set = _set_editable

func _ready() -> void:
	clear()

func _set_editable(value : bool) -> void:
	editable = value
	
	fill.disabled = not value
	repeat.disabled = not value
	interpolation.disabled = not value
	color_space.disabled = not value
	gradient_1d_editor.editable = value
	gradient_2d_editor.editable = value

func clear() -> void:
	var gradient_texture_2d_tmp : GradientTexture2D = GradientTexture2D.new()
	gradient_texture_2d_tmp.gradient = Gradient.new()
	gradient_texture_2d = gradient_texture_2d_tmp
	
	fill.select(0)
	repeat.select(0)
	interpolation.select(0)
	color_space.select(0)
	gradient_1d_editor.clear()
	gradient_2d_editor.clear()

func _set_gradient_texture_2d(value : GradientTexture2D) -> void:
	gradient_texture_2d = value
	
	if gradient_texture_2d != null:
		fill.select(value.fill)
		repeat.select(value.repeat)
		interpolation.select(value.gradient.interpolation_mode)
		color_space.select(value.gradient.interpolation_color_space)
	else:
		fill.select(0)
		repeat.select(0)
		interpolation.select(0)
		color_space.select(0)
	
	gradient_1d_editor.set_gradient(value.gradient)
	gradient_2d_editor.gradient_texture_2d = value

func _on_fill_item_selected(index: int) -> void:
	if gradient_texture_2d == null:
		return
	
	gradient_texture_2d.fill = index as GradientTexture2D.Fill

func _on_repeat_item_selected(index: int) -> void:
	if gradient_texture_2d == null:
		return
	
	gradient_texture_2d.repeat = index as GradientTexture2D.Repeat

func _on_interpoletaion_item_selected(index: int) -> void:
	if gradient_texture_2d == null:
		return
	
	gradient_texture_2d.gradient.interpolation_mode = index as Gradient.InterpolationMode

func _on_color_space_item_selected(index: int) -> void:
	if gradient_texture_2d == null:
		return
	
	gradient_texture_2d.gradient.interpolation_color_space = index as Gradient.ColorSpace
