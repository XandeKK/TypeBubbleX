class_name NumberBox
extends LineEdit

signal value_changed(value : float)

@export var show_arrows : bool = true : set = _set_show_arrows
@export var value : float = 0 : set = _set_value
@export var step : float = 1
@export var min_value : float = 0
@export var max_value : float = 100
@export var allow_greater : bool = true
@export var allow_lesser : bool = true
@export var prefix : String = ""
@export var suffix : String = ""

@onready var arrows : VBoxContainer = $HBoxContainer/VBoxContainer

var line_edit : LineEdit
var range_click_timer : Timer = Timer.new()
var is_up_button_pressed : bool = false
var is_down_button_pressed : bool = false
var modifiable : bool = false : set = _set_modifiable

func _ready() -> void:
	range_click_timer.stop()
	range_click_timer.timeout.connect(range_click_timeout)
	add_child(range_click_timer)
	_update_text()

func _gui_input(event: InputEvent) -> void:
	if not editable:
		return
	
	if event is InputEventMouseButton:
		_handle_mouse_button(event)
		
	if event is InputEventKey:
		_handle_key_input(event)

func _handle_mouse_button(event : InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
		_increase_value()
		caret_column = text.length()
		accept_event()
	elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN  and event.pressed:
		_decrease_value()
		caret_column = text.length()
		accept_event()

func _handle_key_input(event: InputEventKey) -> void:
	if event.is_pressed():
		match event.keycode:
			KEY_UP:
				_increase_value()
				caret_column = text.length()
				accept_event()
			KEY_DOWN:
				_decrease_value()
				caret_column = text.length()
				accept_event()

func range_click_timeout() -> void:
	if is_up_button_pressed:
		_increase_value()
	elif is_down_button_pressed:
		_decrease_value()
	
	if range_click_timer.one_shot:
		range_click_timer.wait_time = 0.035
		range_click_timer.one_shot = false
		range_click_timer.start()

func _update_text() -> void:
	var formatted_value : String = _format_value(value)
	text = formatted_value

func _format_value(_value: float) -> String:
	var value_str : String = String.num(_value)
	
	if localize_numeral_system:
		value_str = Global.TS.format_number(value_str)
	
	if not has_focus():
		if not prefix.is_empty():
			value_str = prefix + " " + value_str
		
		if not suffix.is_empty():
			value_str += " " + suffix
	
	return value_str

func _text_submited(string : String) -> void:
	var parsed_value : Variant = _parse_input(string)
	
	if parsed_value != null:
		value = parsed_value
		
	_update_text()

func _parse_input(string: String) -> Variant:
	if string.is_empty() or string == '-':
		return 0

	var text_to_parse: String = string.replace(",", ".").replace(";", ",")
	
	var expr : Expression = Expression.new()
	var err : Error = expr.parse(text_to_parse)
	
	if err != OK:
		text_to_parse = Global.TS.parse_number(text_to_parse).trim_prefix(prefix + " ").trim_suffix(" " + suffix)
		err = expr.parse(text_to_parse)
		if err != OK:
			return null
	
	return expr.execute(Array(), null, false, true)

func _increase_value() -> void:
	value = value + step

func _decrease_value() -> void:
	value = value - step

func _set_modifiable(_value : bool) -> void:
	modifiable = _value
	editable = modifiable
	show_arrows = modifiable

func _on_text_changed(new_text: String) -> void:
	var cursor_pos : int = caret_column
	
	_text_submited(new_text)
	
	caret_column = cursor_pos

func _set_value(_value : float) -> void:
	if _value < min_value and not allow_lesser:
		value = min_value
	elif _value > max_value and not allow_greater:
		value = max_value
	else:
		value = _value
	
	value_changed.emit(value)
	_update_text()

func _set_show_arrows(_value : bool) -> void:
	show_arrows = _value
	if arrows != null:
		arrows.visible = show_arrows

func start_timer() -> void:
	range_click_timer.wait_time = 0.5
	range_click_timer.one_shot = true
	range_click_timer.start()

func _on_up_button_button_down() -> void:
	_increase_value()
	is_up_button_pressed = true
	start_timer()

func _on_up_button_button_up() -> void:
	is_up_button_pressed = false
	range_click_timer.stop()

func _on_down_button_button_down() -> void:
	_decrease_value()
	is_down_button_pressed = true
	start_timer()

func _on_down_button_button_up() -> void:
	is_down_button_pressed = false
	range_click_timer.stop()

func _on_focus_entered() -> void:
	_update_text()

func _on_focus_exited() -> void:
	_update_text()
