extends Control
# I will keep this code commented here in case it is necessary in the future

#class_name ResizeBubble
#
#var bubble : Bubble = null
#var rect_size : Vector2 = Vector2(20, 20)
#var rects : Array[Rect]
#
#func _init(_bubble : Bubble) -> void:
	#bubble = _bubble
	#bubble.add_child(self)
	#bubble.resized.connect(_on_resized)
	#position = -rect_size
	#
	## Top-Left
	#rects.append(Rect.new(Vector2(0, 0), Vector2(0, 0), Vector2(0, 0)))
	## Top
	#rects.append(Rect.new(Vector2(0, 0), Vector2(1, 0), Vector2(rect_size.x, 0)))
	## Top-Right
	#rects.append(Rect.new(Vector2(1, 0), Vector2(0, 0), Vector2(rect_size.x, 0)))
	## Right
	#rects.append(Rect.new(Vector2(1, 0), Vector2(0, 1), rect_size))
	## Bottom-Right
	#rects.append(Rect.new(Vector2(1, 1), Vector2(0, 0), rect_size))
	## Bottom
	#rects.append(Rect.new(Vector2(0, 1), Vector2(1, 0), rect_size))
	## Bottom-Left
	#rects.append(Rect.new(Vector2(0, 1), Vector2(0, 0), Vector2(0, rect_size.y)))
	## Left
	#rects.append(Rect.new(Vector2(0, 0), Vector2(0, 1), Vector2(0, rect_size.y)))
#
#func _exit_tree() -> void:
	#for rect : Rect in rects:
		#rect.free()
#
#func _gui_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#for rect : Rect in rects:
			#if rect.is_hover:
				#handle_mouse_button_event(rect, event)
	#
	#if event is InputEventMouseMotion:
		#for rect : Rect in rects:
			#handle_mouse_motion_event(rect, event)
#
#func handle_mouse_button_event(rect : Rect, event : InputEventMouseButton) -> void:
	#if event.is_pressed():
		#if not rect.is_dragging:
			#start_dragging(rect, event)
#
	#if rect.is_dragging and not event.is_pressed():
		#stop_dragging(rect)
#
#func start_dragging(rect : Rect, event : InputEventMouseButton) -> void:
	#rect.is_dragging = true
	#rect.position_initial = rect.position
	#rect.mouse_position_initial = event.position
#
#func stop_dragging(rect : Rect) -> void:
	#rect.is_dragging = false
#
#func handle_mouse_motion_event(rect : Rect, event : InputEventMouseMotion) -> void:
	#rect.is_hover = Rect2(rect.position, rect.size).has_point(event.position)
	#queue_redraw()
	#
	#if rect.is_dragging:
		#rect.position = event.position + rect.position_initial - rect.mouse_position_initial
#
#func _draw() -> void:
	#for rect : Rect in rects:
		#if rect.is_hover:
			#draw_rect(Rect2(rect.position, rect.size), Color.GREEN, false)
		#else:
			#draw_rect(Rect2(rect.position, rect.size), Color.PURPLE, false)
#
#func _on_resized() -> void:
	#size = bubble.size + (rect_size * 2)
	#for rect : Rect in rects:
		#rect.update_position(bubble.size)
		#rect.update_size(bubble.size, rect_size)
#
#class Rect extends Node:
	#var position : Vector2
	#var size : Vector2
	#var margin : Vector2
	#var position_percent : Vector2
	#var size_percent : Vector2
	#
	#var position_initial : Vector2
	#var mouse_position_initial: Vector2
	#
	#var is_hover : bool
	#var is_dragging : bool
	#
	#func _init(_position_percent : Vector2, _size_percent : Vector2, _margin : Vector2) -> void:
		#position_percent = _position_percent
		#size_percent = _size_percent
		#margin = _margin
	#
	#func update_position(bubble_size : Vector2) -> void:
		#position = bubble_size * position_percent + margin
	#
	#func update_size(bubble_size : Vector2, rect_size : Vector2) -> void:
		#size.x = rect_size.x if size_percent.x == 0 else bubble_size.x * size_percent.x
		#size.y = rect_size.y if size_percent.y == 0 else bubble_size.y * size_percent.y
