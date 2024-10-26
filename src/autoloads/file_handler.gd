extends Node

var file_processor : FileProcessor = FileProcessor.new()
var raw_images : FileManager
var cleaned_images : FileManager
var tbx_files : FileManager
var bubbles : Array[Dictionary] = []
var navigator_file_handler : Navigator.NavigatorFileHandler = Navigator.NavigatorFileHandler.new()
var paths : Dictionary = {
	'raw': '',
	'cleaned': '',
	'type_bubble_x': ''
}

func open(path : String, artificial_inteligence : bool = false) -> void:
	clear()
	generate_paths(path)
	
	raw_images = FileManager.new(paths.raw, false, '(png|jpeg|jpg|webp)', FileManager.Sort.ASCENDING_NUMERIC)
	cleaned_images = FileManager.new(paths.cleaned, false, '(png|jpeg|jpg|webp)', FileManager.Sort.ASCENDING_NUMERIC)
	tbx_files = FileManager.new(paths.type_bubble_x, false, 'tbx', FileManager.Sort.ASCENDING_NUMERIC)
		
	if artificial_inteligence:
		generate_bubbles()
	else:
		navigator_file_handler.initialize(raw_images.files, cleaned_images.files, tbx_files.files, bubbles)

func clear() -> void:
	if raw_images:
		raw_images.free()
		cleaned_images.free()
		tbx_files.free()
		navigator_file_handler.free()

func generate_paths(path : String) -> void:
	paths.raw = path.path_join(Preferences.general.raw_dir)
	paths.cleaned = path.path_join(Preferences.general.cleaned_dir)
	paths.type_bubble_x = path.path_join(Preferences.general.type_bubble_x_dir)

func generate_bubbles() -> void:
	# Not implemented
	pass

func _exit_tree() -> void:
	file_processor.free()
	raw_images.free()
	cleaned_images.free()
	tbx_files.free()
