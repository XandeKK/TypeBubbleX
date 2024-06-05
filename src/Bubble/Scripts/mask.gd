extends TextureRect
class_name Mask

@onready var brush : Brush = $Brush

var image : Image
var image_texture : ImageTexture
var active : bool = false : set = set_active

func generate_image() -> void:
	image = Image.create(size.x as int, size.y as int, false, Image.FORMAT_RGBA8)
	image.fill(Color.BLACK)
	image_texture = ImageTexture.create_from_image(image)
	texture = image_texture

func _on_resized():
	generate_image()

func set_active(value : bool) -> void:
	active = value
	brush.set_process_input(active)

func reset() -> void:
	image.fill(Color.BLACK)
	image_texture.update(image)
