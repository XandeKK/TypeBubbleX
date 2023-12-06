extends TextureRect

func set_pattern(path : String):
	var image : Image = Image.load_from_file(path)
	texture = ImageTexture.create_from_image(image)
