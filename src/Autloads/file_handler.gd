extends Node

var canvas : SubViewportContainer : set = set_canvas
var cleaned_images_path : Array : get = get_cleaned_images_path
var raw_images_path : Array
var current_page : int = 0 : get = get_current_page
var text_list : ItemList : set = _set_text_list
var default_path : String
var cleaned_path : String
var raw_path : String

signal page_changed
signal pages_add

func open(obj : Dictionary):
	current_page = 0
	
	default_path = obj['path']
	
	cleaned_path = default_path.path_join('cleaned')
	raw_path = default_path.path_join('raw')
	var text_path : String = default_path.path_join('text.txt')
	
	if not DirAccess.dir_exists_absolute(cleaned_path):
		print('there are no cleaned path')
		return
		
	cleaned_images_path = Array(DirAccess.get_files_at(cleaned_path))
	cleaned_images_path = remove_files_non_images(cleaned_images_path)
	
	organize_files(cleaned_images_path)
	
	if DirAccess.dir_exists_absolute(raw_path):
		raw_images_path = Array(DirAccess.get_files_at(raw_path))
		raw_images_path = remove_files_non_images(raw_images_path)
		
		organize_files(raw_images_path)
	
	set_texts(text_path)
	
	emit_signal('pages_add')
	
	load_image_in_canvas()
	
	canvas.style = obj['style']

func save() -> void:
	var data : Dictionary = canvas.to_dictionary()
	
	handler_fonts(data)
	handler_images(data)
	
	var save_path : String = default_path.path_join('saves')
	if not DirAccess.dir_exists_absolute(save_path):
		DirAccess.make_dir_recursive_absolute(save_path)
	save_path = save_path.path_join(cleaned_images_path[current_page]).get_basename()
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(data, true)
	
	save_image()

func save_image() -> void:
	var image : Image = await canvas.get_image()
	
	var save_path : String = default_path.path_join('images')
	if not DirAccess.dir_exists_absolute(save_path):
		DirAccess.make_dir_recursive_absolute(save_path)
	
	save_path = save_path.path_join(cleaned_images_path[current_page])

	if cleaned_images_path[current_page].ends_with('.png'):
		image.save_png(save_path)
	elif cleaned_images_path[current_page].ends_with('.jpg') or cleaned_images_path[current_page].ends_with('.jpeg'):
		image.save_jpg(save_path)
	elif cleaned_images_path[current_page].ends_with('.webp'):
		image.save_webp(save_path)

func handler_fonts(data : Dictionary) -> void:
	data.fonts = {}
	for text in data.texts:
		if not data.fonts.has(text.text.font_name) and text.text.font_name:
			data.fonts[text.text.font_name] = FontConfigManager.fonts[text.text.font_name]
		for text_style in text.text.text_styles.list:
			if not data.fonts.has(text_style.font_name):
				data.fonts[text_style.font_name] = FontConfigManager.fonts[text_style.font_name]

func handler_images(data : Dictionary) -> void:
	if cleaned_images_path[current_page].ends_with('.png'):
		data.raw_image = data.raw_image.save_png_to_buffer()
		data.cleaned_image = data.cleaned_image.save_png_to_buffer()
	elif cleaned_images_path[current_page].ends_with('.jpg') or cleaned_images_path[current_page].ends_with('.jpeg'):
		data.raw_image = data.raw_image.save_jpg_to_buffer()
		data.cleaned_image = data.cleaned_image.save_jpg_to_buffer()
	elif cleaned_images_path[current_page].ends_with('.webp'):
		data.raw_image = data.raw_image.save_webp_to_buffer()
		data.cleaned_image = data.cleaned_image.save_webp_to_buffer()

func next():
	if current_page == cleaned_images_path.size() - 1:
		return
	
	current_page += 1
	
	load_image_in_canvas()

func back():
	if current_page == 0:
		return
	
	current_page -= 1
	
	load_image_in_canvas()

func to_go(index : int):
	if index < 0 or index > cleaned_images_path.size() - 1:
		return
	
	current_page = index
	
	load_image_in_canvas()

func add_path_absolute(files : Array, path : String):
	return files.map(func(file): return path.path_join(file))

func load_image_in_canvas():
	if cleaned_images_path.is_empty():
		print('there are no images')
		return
	
	canvas.load_cleaned_image(load_image(cleaned_path.path_join(cleaned_images_path[current_page])))
	if not raw_images_path.is_empty():
		canvas.load_raw_image(load_image(raw_path.path_join(raw_images_path[current_page])))
	
	emit_signal('page_changed')

func remove_files_non_images(files : Array):
	return files.filter(func(file): return file.ends_with('.png') or file.ends_with('.jpg') or file.ends_with('.jpeg') or file.ends_with('.webp'))

func organize_files(files : Array):
	files.sort_custom(compare_files)

func compare_files(a, b):
	var a_number = int(a.get_basename())
	var b_number = int(b.get_basename())
	return a_number < b_number

func load_image(path : String) -> ImageTexture:
	var image = Image.new()
	var texture = ImageTexture.new()

	image.load(path)
	texture.set_image(image)

	return texture

func set_canvas(value : SubViewportContainer):
	canvas = value

func set_texts(path_texts) -> void:
	if not path_texts:
		return
	
	var file = FileAccess.open(path_texts, FileAccess.READ)
	if file:
		text_list.clear()
		var content = file.get_as_text()
		for line in content.split('\n'):
			if line.is_empty():
				continue
			text_list.add_item(line)

func get_current_page():
	return current_page

func get_cleaned_images_path():
	return cleaned_images_path

func _set_text_list(value : ItemList) -> void:
	text_list = value
