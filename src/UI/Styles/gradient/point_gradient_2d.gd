extends Control

var parent : TextureRect

var is_dragging : float = false
var drag_offset : Vector2
var is_within : float = false

var target_inital : Vector2
var mouse_inital : Vector2

signal position_changed

func _ready():
	parent = get_parent()
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _draw():
	draw_rect(Rect2(Vector2(-1, -1), size + Vector2(2, 2)), Color.BLACK)
	draw_rect(Rect2(Vector2.ZERO, size), Color.WHITE)

func _input(event : InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if is_within and event.is_pressed():
			if not is_dragging:
				is_dragging = true
				target_inital = position
				mouse_inital = event.position
		if is_dragging and not event.is_pressed():
			is_dragging = false
	
	if event is InputEventMouseMotion and is_dragging:
		drag_offset = target_inital - mouse_inital
		position = event.position + drag_offset
		
		var half_size = size.x / 2
		position.x = min(max(position.x, -half_size), parent.size.x - half_size)
		position.y = min(max(position.y, -half_size), parent.size.y - half_size)
		
		emit_signal('position_changed')

func _on_mouse_entered():
	is_within = true

func _on_mouse_exited():
	is_within = false
