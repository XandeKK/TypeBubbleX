extends Node
class_name ProcessFile

# Add error
# Add thread in save image

func load_image(path : String) -> Image:
	return Image.load_from_file(path)

func get_file_var(path : String) -> Dictionary:
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
	
	return image

func save_image(image : Image, path : String) -> void:
	var extension : String = path.get_extension()
	
	if extension == 'png':
		image.save_png(path)
	elif extension == 'jpg' or extension == 'jpeg':
		image.save_jpg(path)
	elif extension == 'webp': 
		image.save_webp(path)

func save_image_buffer(image : Image, extension : String) -> PackedByteArray:
	if extension == 'png':
		return image.save_png_to_buffer()
	elif extension == 'jpg' or extension == 'jpeg':
		return image.save_jpg_to_buffer()
	elif extension == 'webp': 
		return image.save_webp_to_buffer()
	
	return PackedByteArray()

func save_file_var(data : Dictionary, path : String) -> void:
	var file : FileAccess = FileAccess.open(path, FileAccess.WRITE)
	
	file.store_var(data)
	file.close()
