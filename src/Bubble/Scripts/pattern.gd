extends TextureRect
class_name Pattern

var image : Image
var active : bool = false : set = set_active

func load_image(path : String) -> void:
	image = Image.load_from_file(path)
	texture = ImageTexture.create_from_image(image)

func clear():
	image = null
	texture = null

func set_active(value : bool) -> void:
	active = value

func to_dictionary() -> Dictionary:
	return {
		'image': image.save_jpg_to_buffer()
	}

func load(data : Dictionary) -> void:
	image = Image.create(size.x as int, size.y as int, true, Image.FORMAT_RGBA8)
	image.load_png_from_buffer(data['image'])
	texture = ImageTexture.create_from_image(image)
