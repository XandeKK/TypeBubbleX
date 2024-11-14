class_name FileProcessor
extends Node

var thread: Thread
var error : Error

func _init() -> void:
	thread = Thread.new()

func _exit_tree():
	if thread.is_started():
		thread.wait_to_finish()

func load_image(path : String) -> Image:
	return Image.load_from_file(path)

func get_file_var(path : String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_error("File does not exist: " + path)
		error = Error.ERR_FILE_NOT_FOUND
		return {}
	
	var file : FileAccess = FileAccess.open(path, FileAccess.READ)
	var data : Dictionary = file.get_var()
	file.close()
	
	return data

func load_image_buffer(buffer : PackedByteArray, extension : String) -> Image:
	var image : Image = Image.new()
	
	if extension == 'png':
		image.load_png_from_buffer(buffer)
	elif extension == 'jpg' or extension == 'jpeg':
		image.load_jpg_from_buffer(buffer)
	elif extension == 'webp':
		image.load_webp_from_buffer(buffer)
	else:
		error = Error.ERR_UNAVAILABLE
		push_error("Invalid extension")
	
	return image

func save_image(image : Image, path : String) -> void:
	if thread.is_started():
		thread.wait_to_finish()
	thread.start(_thread_save_image.bind(image, path))
	
func _thread_save_image(image : Image, path : String) -> void:
	var extension : String = path.get_extension()
	
	if extension == 'png':
		image.save_png(path)
	elif extension == 'jpg' or extension == 'jpeg':
		image.save_jpg(path)
	elif extension == 'webp':
		image.save_webp(path)
	else:
		error = Error.ERR_UNAVAILABLE
		push_error("Invalid extension")

func save_image_buffer(image : Image, extension : String, emit_signal_callable : Callable) -> void:
	if thread.is_started():
		thread.wait_to_finish()
	thread.start(_thread_save_image_buffer.bind(image, extension, emit_signal_callable))
	
func _thread_save_image_buffer(image : Image, extension : String, emit_signal_callable : Callable) -> void:
	if extension == 'png':
		emit_signal_callable.call_deferred(image.save_png_to_buffer())
	elif extension == 'jpg' or extension == 'jpeg':
		emit_signal_callable.call_deferred(image.save_jpg_to_buffer())
	elif extension == 'webp':
		emit_signal_callable.call_deferred(image.save_webp_to_buffer())
	else:
		error = Error.ERR_UNAVAILABLE
		push_error("Invalid extension")
		emit_signal_callable.call_deferred([])

func save_file_var(data : Dictionary, path : String) -> void:
	var file : FileAccess = FileAccess.open(path, FileAccess.WRITE)
	
	file.store_var(data)
	file.close()
