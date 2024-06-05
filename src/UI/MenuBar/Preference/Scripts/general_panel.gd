extends PanelContainer

@onready var font_size : _Input = $ScrollContainer/MarginContainer/VBoxContainer/FontSizeInput
@onready var raw_path : _Input = $ScrollContainer/MarginContainer/VBoxContainer/RawPathInput
@onready var cleaned_path : _Input = $ScrollContainer/MarginContainer/VBoxContainer/CleanedPathInput
@onready var text_filename : _Input = $ScrollContainer/MarginContainer/VBoxContainer/TextFilenameInput

@onready var url : _Input = $ScrollContainer/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/URLInput
@onready var port : _Input = $ScrollContainer/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/PortInput

@onready var min_zoom : _Input = $ScrollContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/MinZoomInput
@onready var max_zoom : _Input = $ScrollContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/MaxZoomInput
@onready var zoom_rate : _Input = $ScrollContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ZoomRateInput

func _ready():
	font_size.default_value = Preference.default_general.font_size
	raw_path.default_value = Preference.default_general.raw_path
	cleaned_path.default_value = Preference.default_general.cleaned_path
	text_filename.default_value = Preference.default_general.text_filename
	url.default_value = Preference.default_general.url
	port.default_value = Preference.default_general.port
	min_zoom.default_value = Preference.default_general.camera.min_zoom
	max_zoom.default_value = Preference.default_general.camera.max_zoom
	zoom_rate.default_value = Preference.default_general.camera.zoom_rate
	
	font_size.set_value(Preference.general.font_size)
	raw_path.set_value(Preference.general.raw_path)
	cleaned_path.set_value(Preference.general.cleaned_path)
	text_filename.set_value(Preference.general.text_filename)
	url.set_value(Preference.general.url)
	port.set_value(Preference.general.port)
	min_zoom.set_value(Preference.general.camera.min_zoom)
	max_zoom.set_value(Preference.general.camera.max_zoom)
	zoom_rate.set_value(Preference.general.camera.zoom_rate)

func _on_font_size_input_changed(value):
	Preference.general.font_size = value
	Preference.load_general()
	Preference.save_configuration()

func _on_raw_path_input_changed(value):
	Preference.general.raw_path = value
	Preference.save_configuration()

func _on_cleaned_path_input_changed(value):
	Preference.general.cleaned_path = value
	Preference.save_configuration()

func _on_text_filename_input_changed(value):
	Preference.general.text_filename = value
	Preference.save_configuration()

func _on_url_input_changed(value):
	Preference.general.url = value
	Preference.save_configuration()

func _on_port_input_2_changed(value):
	Preference.general.port = value
	Preference.save_configuration()

func _on_min_zoom_input_changed(value):
	Preference.general.camera.min_zoom = value
	Preference.save_configuration()

func _on_max_zoom_input_changed(value):
	Preference.general.camera.max_zoom = value
	Preference.save_configuration()

func _on_zoom_rate_input_changed(value):
	Preference.general.camera.zoom_rate = value
	Preference.save_configuration()
