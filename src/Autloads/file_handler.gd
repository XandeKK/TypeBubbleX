extends Node

var canvas : SubViewportContainer : set = set_canvas
var cleaned_images_path : Array : get = get_cleaned_images_path
var raw_images_path : Array
var current_page : int = 0 : get = get_current_page
var text_list : ItemList : set = _set_text_list

signal page_changed
signal pages_add

func open(obj : Dictionary):
	current_page = 0
	
	cleaned_images_path = Array(DirAccess.get_files_at(obj['cleaned']))
	cleaned_images_path = remove_files_non_images(cleaned_images_path)
	
	organize_files(cleaned_images_path)

	cleaned_images_path = add_path_absolute(cleaned_images_path, obj['cleaned'])
	
	if obj['raw']:
		raw_images_path = Array(DirAccess.get_files_at(obj['raw']))
		raw_images_path = remove_files_non_images(raw_images_path)
		
		organize_files(raw_images_path)
		
		raw_images_path = add_path_absolute(raw_images_path, obj['raw'])
	
	emit_signal('pages_add')
	
	set_texts(obj['texts'])
	
	load_image_in_canvas()
	
	canvas.style = obj['style']

func save():
	var file = FileAccess.open("/home/xandekk/Documents/image.typex", FileAccess.WRITE)
	file.store_var(canvas.to_dictionary(), true)

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
	canvas.load_cleaned_image(load_image(cleaned_images_path[current_page]))
	if not raw_images_path.is_empty():
		canvas.load_raw_image(load_image(raw_images_path[current_page]))
	
	emit_signal('page_changed')

func remove_files_non_images(files : Array):
	return files.filter(func(file): return file.ends_with('.png') or file.ends_with('.jpg') or file.ends_with('.jpeg') or file.ends_with('.gif'))

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
