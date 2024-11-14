class_name PatternText
extends TextureRect

var image : Image

func clear() -> void:
	image.free()
	
	texture = null
	image = null

func load_image(path : String = "",  packed_byte_array : PackedByteArray = []) -> void:
	if not path.is_empty():
		image = Image.load_from_file(path)
	else:
		image.load_jpg_from_buffer(packed_byte_array)
	
	texture = ImageTexture.create_from_image(image)

func to_dictionary() -> Dictionary:
	return {
		'image': image.save_jpg_to_buffer()
	}

func load(data : Dictionary) -> void:
	image = Image.create(size.x as int, size.y as int, true, Image.FORMAT_RGBA8)
	load_image("", data['image'])
