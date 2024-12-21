extends Control

@onready var start : NumberBox = $VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer/Start
@onready var end : NumberBox = $VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer/End
@onready var x : NumberBox = $VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer2/X
@onready var y : NumberBox = $VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer2/Y
@onready var size_box : NumberBox = $VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer3/Size
@onready var blur : NumberBox = $VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer3/Blur
@onready var fill : CheckButton = $VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer4/Fill
@onready var color : ColorPickerButton = $VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer4/Color

var outline : Outline : set = _set_outline
var outline_manager : OutlineManager

func _set_outline(value : Outline) -> void:
	outline = value
	start.value = outline.start
	end.value = outline.end
	x.value = outline.offset.x
	y.value = outline.offset.y
	size_box.value = outline.outline_size
	fill.button_pressed = outline.fill
	color.color = outline.color
	
	if outline.blur_outline != null:
		blur.value = outline.blur_outline.blur_size

func _on_delete_pressed() -> void:
	outline_manager.remove(outline)
	queue_free()

func _on_start_value_changed(value: float) -> void:
	if outline == null:
		return
	
	outline.start = value as int

func _on_end_value_changed(value: float) -> void:
	if outline == null:
		return
	
	outline.end = value as int

func _on_x_value_changed(value: float) -> void:
	if outline == null:
		return
	
	outline.offset.x = value

func _on_y_value_changed(value: float) -> void:
	if outline == null:
		return
	
	outline.offset.y = value

func _on_size_value_changed(value: float) -> void:
	if outline == null:
		return
	
	outline.outline_size = value as int

func _on_blur_value_changed(value: float) -> void:
	if outline == null:
		return
	
	if value == 0 and outline.blur_outline != null:
		outline.remove_blur()
	elif value != 0 and outline.blur_outline == null:
		outline.add_blur()
		outline.blur_outline.blur_size = value as int
	else:
		outline.blur_outline.blur_size = value as int

func _on_fill_toggled(toggled_on: bool) -> void:
	if outline == null:
		return
	
	outline.fill = toggled_on

func _on_color_color_changed(_color: Color) -> void:
	if outline == null:
		return
	
	outline.color = _color
