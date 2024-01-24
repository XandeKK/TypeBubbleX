extends TextureRect

@export var color_picker_button : ColorPickerButton

@onready var point_gradient_1d : Control = $PointGradient1D

var points : Array[Control]
var point_focused : Control : set = _set_point_focused

func _ready():
	point_gradient_1d = point_gradient_1d.duplicate()
	$PointGradient1D.queue_free()

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var _point_gradient_1d : Control = point_gradient_1d.duplicate()
		
		add_child(_point_gradient_1d)
		points.append(_point_gradient_1d)
		
		_point_gradient_1d.position_changed.connect(_on_point_position_changed)
		
		_point_gradient_1d.position.x = event.position.x - _point_gradient_1d.size.x / 2
		_point_gradient_1d.visible = true
		_point_gradient_1d.point = points.size() - 1
		
		var color = texture.gradient.sample(_point_gradient_1d.position.x / size.x)
		_point_gradient_1d.color = color
		
		texture.gradient.add_point(_point_gradient_1d.position.x / size.x, color)
		
		sort_points()
		point_focused = _point_gradient_1d

func clear() -> void:
	points.clear()
	texture.gradient = Gradient.new()
	point_focused = null

	for child in get_children():
		child.queue_free()

func set_gradient(value : Gradient) -> void:
	texture.gradient = value
	
	for i in range(texture.gradient.get_point_count()):
		var _point_gradient_1d : Control = point_gradient_1d.duplicate()
		
		add_child(_point_gradient_1d)
		points.append(_point_gradient_1d)
		
		_point_gradient_1d.position_changed.connect(_on_point_position_changed)
		
		_point_gradient_1d.color = texture.gradient.get_color(i)
		_point_gradient_1d.position.x = size.x * texture.gradient.get_offset(i) - _point_gradient_1d.size.x / 2
		_point_gradient_1d.visible = true
		_point_gradient_1d.point = i
		
		sort_points()

func set_color(point : int, color : Color) -> void:
	texture.gradient.set_color(point, color)

func _on_point_position_changed(_point_gradient_1d : Control) -> void:
	texture.gradient.set_offset(_point_gradient_1d.point, (_point_gradient_1d.position.x + _point_gradient_1d.size.x / 2) / size.x)
	
	sort_points()

func sort_points() -> void:
	var children = get_children()
	points.sort_custom(func(a, b): return a.position.x < b.position.x)
	
	if not children == points:
		for child in children:
			remove_child(child)
		
		var count = 0
		for _point_gradient_1d in points:
			add_child(_point_gradient_1d)
			_point_gradient_1d.point = count
			count += 1

func remove_point(_point_gradient_1d : Control) -> void:
	if points.size() <= 1:
		return
	if _point_gradient_1d == point_focused:
		point_focused = null
	
	texture.gradient.remove_point(_point_gradient_1d.point)
	points.remove_at(points.find(_point_gradient_1d))
	sort_points()
	_point_gradient_1d.queue_free()

func _set_point_focused(value : Control) -> void:
	point_focused = value
	
	if point_focused:
		color_picker_button.color = point_focused.color
	else:
		color_picker_button.color = Color(Color.ALICE_BLUE, 0)

func _on_color_picker_button_color_changed(color):
	if point_focused:
		point_focused.color = color
		point_focused.queue_redraw()
		set_color(point_focused.point, color)

func _exit_tree():
	point_gradient_1d.queue_free()
