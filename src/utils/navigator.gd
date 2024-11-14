class_name Navigator
extends Node

class NavigatorFileHandler:
	signal element_changed(current_element : Dictionary)
	
	var index : int = 0
	
	var raw_images : Array[String]
	var cleaned_images : Array[String]
	var tbx_files : Array[String]
	var bubbles : Array[Dictionary]
	
	func initialize(_raw_images : Array[String], _cleaned_images : Array[String], _tbx_files : Array[String], _bubbles : Array[Dictionary]) -> void:
		raw_images = _raw_images
		cleaned_images = _cleaned_images
		tbx_files = _tbx_files
		bubbles = _bubbles
		
		element_changed.emit(get_current_element())

	func get_current_element() -> Dictionary:
		var current_element : Dictionary = {
			'raw_path': '',
			'cleaned_path': cleaned_images[index],
			'tbx_file_path': '',
			'bubbles': []
		}
		
		var raw_images_temp : Array = raw_images.filter(func(raw_image): return are_filenames_equal(raw_image, cleaned_images[index]))
		
		if not raw_images_temp.is_empty():
			current_element.raw_path = raw_images_temp[0]
		
		var tbx_files_temp : Array = tbx_files.filter(func(tbx_file): return are_filenames_equal(tbx_file, cleaned_images[index]))
		
		if not tbx_files_temp.is_empty():
			current_element.tbx_file_path = tbx_files_temp[0]
		
		if index >= 0 and index < bubbles.size():
			current_element.bubbles = bubbles[index]
		
		return current_element

	func are_filenames_equal(a : String, b : String) -> bool:
		return a.get_file().get_basename() == b.get_file().get_basename()

	func update_bubbles(_bubbles : Array[Dictionary]) -> void:
		bubbles = _bubbles

	func forward() -> void:
		if index == cleaned_images.size() - 1 or cleaned_images.size() == 0:
			return
		
		index += 1
		
		element_changed.emit(get_current_element())

	func back() -> void: 
		if index == 0:
			return
		
		index -= 1
		
		element_changed.emit(get_current_element())

	func to_go(_index : int) -> void:
		if _index < 0 or _index > cleaned_images.size() - 1:
			return
		
		index = _index
		
		element_changed.emit(get_current_element())
