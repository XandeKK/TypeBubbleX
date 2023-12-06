extends TextureRect

func _ready():
	texture = GradientTexture2D.new()
	texture.fill = GradientTexture2D.FILL_RADIAL
	texture.fill_from = Vector2(0.5, 0.5)
	texture.fill_to = Vector2(0, 0)
	texture.gradient = Gradient.new()
	texture.gradient.set_color(0, Color('0945ff'))
	texture.gradient.set_color(1, Color(Color.BLACK, 0))
