extends TextureRect
class_name Pattern

var image : String

func load_image(path : String) -> void:
	texture = FileHandler.load_image(path)
	image = path

func remove_image() -> void:
	texture = null
	image = ''

func to_dictionary() -> Dictionary:
	return {
		'image': image
	}

func load(data : Dictionary) -> void:
	load_image(data['image'])
