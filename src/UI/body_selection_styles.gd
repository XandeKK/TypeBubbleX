extends VBoxContainer

@onready var start_input : LineEdit = $StartContainer/StartInput
@onready var end_input : LineEdit = $EndContainer/EndInput
@onready var font_input : LineEdit = $FontContainer/FontName
@onready var font_size_input : LineEdit = $FontContainer/HBoxContainer/FontSize
@onready var color_input : ColorPickerButton = $FontContainer/HBoxContainer/Color
@onready var bold_check_button : CheckButton = $BoldItalicContainer/Bold
@onready var italic_check_button : CheckButton = $BoldItalicContainer/Italic
@onready var body_outlines : PanelContainer = $BodyOutlines
@onready var body_shakes : PanelContainer = $BodyShakes

var node : TextStyle : set = _set_node
var parent :  : set = _set_parent

func _ready():
	font_input.callable_search = search_font
	font_input.list = FontConfigManager.fonts
	font_input.key = 'font'

func search_font(font : Dictionary, new_text : String):
	return font['font'].to_lower().contains(new_text) or \
		font['nickname'] != null and font['nickname'].to_lower().contains(new_text)

func _set_node(value : TextStyle) -> void:
	if not value:
		return
	node = value
	
	start_input.text = str(node.start)
	end_input.text = str(node.end)
	font_input.text = node.font_name
	font_size_input.text = str(node.font_size)
	color_input.color = node.color
	bold_check_button.button_pressed = node.bold
	italic_check_button.button_pressed = node.italic
	
	body_outlines.node = node
	body_shakes.node = node

func _set_parent(value : Panel) -> void:
	parent = value

func _on_remove_button_pressed():
	parent.remove_selection_style(node)
	node.remova_all()
	queue_free()

func _on_start_input_changed(value):
	if not node:
		return
	
	if value < 0:
		start_input.text = '0'
	elif value > node.end:
		start_input.text = str(node.end)
	else:
		node.start = value

func _on_end_input_changed(value):
	if not node:
		return
	
	if value < node.start:
		end_input.text = str(node.start)
	else:
		node.end = value

func _on_font_size_changed(value):
	if not node:
		return
	
	node.font_size = value

func _on_color_color_changed(color):
	if not node:
		return
	
	node.color = color

func _on_bold_toggled(toggled_on):
	if not node:
		return
	
	node.bold = toggled_on

func _on_italic_toggled(toggled_on):
	if not node:
		return
	
	node.italic = toggled_on

func _on_font_name_changed(value):
	if not node:
		return
	
	node.font_name = value
	node.font_settings = FontConfigManager.fonts[value]
