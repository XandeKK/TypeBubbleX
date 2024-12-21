extends Node

signal bubble_focused(bubble : Bubble)
@warning_ignore("unused_signal")
signal bubble_added(bubble: Bubble)
@warning_ignore("unused_signal")
signal bubble_removed(bubble: Bubble)

var TS : TextServer = TextServerManager.get_primary_interface() : get = get_text_server
var focused_bubble : Bubble = null : set = set_focused_bubble
var top_canvas : TopCanvas = null
var current_comic : Dictionary

var bubble_scene : PackedScene = load("res://src/bubble/scenes/bubble.tscn")

var outline_scene : PackedScene = load("res://src/bubble/scenes/outline.tscn")
var blur_outline_scene : PackedScene = load("res://src/bubble/scenes/blur_outline.tscn")

var gradient_text_scene : PackedScene = load("res://src/bubble/scenes/gradient_text.tscn")
var pattern_text_scene : PackedScene = load("res://src/bubble/scenes/pattern_text.tscn")

var mask_bubble_scene : PackedScene = load('res://src/bubble/scenes/mask_bubble.tscn')

var sub_viewport_perspective_scene : PackedScene = load("res://src/bubble/sub_viewports/scenes/sub_viewport_shader_perspective.tscn")
var sub_viewport_blur_scene : PackedScene = load("res://src/bubble/sub_viewports/scenes/sub_viewport_shader_blur.tscn")
var sub_viewport_motion_blur_scene : PackedScene = load("res://src/bubble/sub_viewports/scenes/sub_viewport_shader_motion_blur.tscn")

var number_box : PackedScene = load("res://src/ui/components/scenes/number_box.tscn")

func _ready() -> void:
	current_comic = Preferences.comics[0]

func get_text_server() -> TextServer:
	return TS

func set_focused_bubble(value : Bubble) -> void:
	focused_bubble = value

	bubble_focused.emit(focused_bubble)
	
	var bubbles : Array[Node] = get_tree().get_nodes_in_group('Bubbles')
	
	for bubble : Bubble in bubbles:
		if bubble != focused_bubble:
			bubble.set_focus(false)

func update_scene_hierarchy_indices() -> void:
	var bubbles : Array[Node] = get_tree().get_nodes_in_group('Bubbles')
	
	for bubble : Bubble in bubbles:
		if bubble.get_index() != bubble.scene_hierarchy_index:
			bubble.scene_hierarchy_index = bubble.get_index()

func _notification(what: int):
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		get_tree().paused = true
	elif what == NOTIFICATION_APPLICATION_FOCUS_IN:
		get_tree().paused = false
