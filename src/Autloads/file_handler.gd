extends Node

var thread: Thread

var canvas : SubViewportContainer : set = set_canvas
var cleaned_images_path : Array : get = get_cleaned_images_path
var raw_images_path : Array
var app_files_images_path : Array
var current_page : int = 0 : get = get_current_page
var text_list : ItemList : set = _set_text_list
var default_path : String
var cleaned_path : String
var raw_path : String
var app_files_path : String

var http_request : HTTPRequest : set = _set_http_request
var boxes : Array

var can_change_page : bool = true

signal page_changed
signal pages_add

func _ready():
	thread = Thread.new()

func open(obj : Dictionary) -> void:
	current_page = 0
	default_path = obj['path']
	
	canvas.clear()
	text_list.clear()
	
	set_paths(default_path)
	
	if not DirAccess.dir_exists_absolute(cleaned_path):
		Notification.message(tr('KEY_THERE_ARE_NO_CLEANED_PATH'))
		return
	
	process_cleaned_images(cleaned_path)
	process_raw_images(raw_path)
	process_app_files(app_files_path)
	
	set_texts(default_path.path_join('text.txt'))
	
	emit_signal('pages_add')
	
	load_image_in_canvas()
	
	canvas.style = obj['style']
	
	request_boxes()

func request_boxes() -> void:
	var url = 'http://localhost:5000/detect_boxes'
	var headers = ["Content-Type: application/json"]
	
	if raw_images_path.size() > 0:
		var json = JSON.stringify({'directory_path': raw_path, 'style': Preference.hq_styles_string[canvas.style]})
		http_request.request(url, headers, HTTPClient.METHOD_POST, json)
	else:
		var json = JSON.stringify({'directory_path': cleaned_path, 'style': Preference.hq_styles_string[canvas.style]})
		http_request.request(url, headers, HTTPClient.METHOD_POST, json)
	Notification.message(tr("KEY_STARTED_BOXES"))

func set_paths(path : String) -> void:
	cleaned_path = path.path_join('cleaned')
	raw_path = path.path_join('raw')
	app_files_path = path.path_join('app_files')

func process_cleaned_images(path : String) -> void:
	if DirAccess.dir_exists_absolute(path):
		cleaned_images_path = Array(DirAccess.get_files_at(path))
		cleaned_images_path = remove_files_non_images(cleaned_images_path)
		organize_files(cleaned_images_path)

func process_raw_images(path : String) -> void:
	if DirAccess.dir_exists_absolute(path):
		raw_images_path = Array(DirAccess.get_files_at(path))
		raw_images_path = remove_files_non_images(raw_images_path)
		organize_files(raw_images_path)

func process_app_files(path : String) -> void:
	if DirAccess.dir_exists_absolute(path):
		app_files_images_path = Array(DirAccess.get_files_at(path))
		app_files_images_path.filter(func(file): return file.ends_with('.typex'))
		organize_files(app_files_images_path)

func save() -> void:
	if cleaned_images_path.is_empty():
		Notification.message(tr('KEY_YOU_CANT_SAVE_IMAGE'))
		return

	var data : Dictionary = canvas.to_dictionary()
	
	save_to_file(data)
	update_app_file()
	save_image()

func export_to_json() -> void:
	if cleaned_images_path.is_empty():
		Notification.message(tr('KEY_YOU_CANT_EXPORT'))
		return

	var data : Dictionary = canvas.to_dictionary()
	
	var save_path : String = app_files_path.replace('app_files', 'json')
	if not DirAccess.dir_exists_absolute(save_path):
		DirAccess.make_dir_recursive_absolute(save_path)
	save_path = save_path.path_join(cleaned_images_path[current_page]).get_basename()
	
	var file = FileAccess.open(save_path + '.json', FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	Notification.message(tr('KEY_JSON_EXPORTED'))
	copy_font(data, app_files_path.replace('app_files', 'fonts'))

func copy_font(data : Dictionary, output : String) -> void:
	if not DirAccess.dir_exists_absolute(output):
		DirAccess.make_dir_recursive_absolute(output)
	
	for text in data.texts:
		var bold = text.text.bold
		var italic = text.text.italic
		var filename : String
		
		if bold and italic:
			filename = text.text.extra_info_for_photoshop.fonts['bold-italic'].split('/')[-1]
			DirAccess.copy_absolute(text.text.extra_info_for_photoshop.fonts['bold-italic'], output.path_join(filename))
		elif bold:
			filename = text.text.extra_info_for_photoshop.fonts['bold'].split('/')[-1]
			DirAccess.copy_absolute(text.text.extra_info_for_photoshop.fonts['bold'], output.path_join(filename))
		elif italic:
			filename = text.text.extra_info_for_photoshop.fonts['italic'].split('/')[-1]
			DirAccess.copy_absolute(text.text.extra_info_for_photoshop.fonts['italic'], output.path_join(filename))
		else:
			filename = text.text.extra_info_for_photoshop.fonts['regular'].split('/')[-1]
			DirAccess.copy_absolute(text.text.extra_info_for_photoshop.fonts['regular'], output.path_join(filename))

func save_to_file(data: Dictionary) -> void:
	if cleaned_images_path.is_empty():
		Notification.message(tr('KEY_YOU_CANT_SAVE_IMAGE'))
		return

	var save_path : String = app_files_path
	if not DirAccess.dir_exists_absolute(save_path):
		DirAccess.make_dir_recursive_absolute(save_path)
	save_path = save_path.path_join(cleaned_images_path[current_page]).get_basename()
	
	var file = FileAccess.open(save_path + '.typex', FileAccess.WRITE)
	file.store_var(data)
	file.close()

func update_app_file() -> void:
	if cleaned_images_path.is_empty():
		return

	var filename_load : String = cleaned_images_path[current_page].get_basename() + '.typex'
	
	if not app_files_images_path.has(filename_load):
		app_files_images_path.append(filename_load)
		organize_files(app_files_images_path)

func save_image() -> void:
	if cleaned_images_path.is_empty():
		Notification.message(tr('KEY_YOU_CANT_SAVE_IMAGE'))
		return

	var image : Image = await canvas.get_image()
	
	var save_path : String = default_path.path_join('images')
	if not DirAccess.dir_exists_absolute(save_path):
		DirAccess.make_dir_recursive_absolute(save_path)
	
	Notification.message(tr('KEY_SAVING_THE_IMAGE_PLEASE_WAIT_A_MOMENT'))
	save_path = save_path.path_join(cleaned_images_path[current_page])

	if thread.is_started():
		thread.wait_to_finish()
	thread.start(_thread_save_image.bind(image, save_path))

func _thread_save_image(image : Image, save_path : String) -> void:
	if cleaned_images_path[current_page].ends_with('.png'):
		image.save_png(save_path)
	elif cleaned_images_path[current_page].ends_with('.jpg') or cleaned_images_path[current_page].ends_with('.jpeg'):
		image.save_jpg(save_path)
	elif cleaned_images_path[current_page].ends_with('.webp'):
		image.save_webp(save_path)
	
	Notification.call_deferred_thread_group('message', "Saved image")

func get_image_extension(file_path: String) -> String:
	if file_path.ends_with('.png'):
		return 'png'
	elif file_path.ends_with('.jpg') or file_path.ends_with('.jpeg'):
		return 'jpg'
	elif file_path.ends_with('.webp'):
		return 'webp'
	else:
		return ''

func next() -> void:
	if current_page == cleaned_images_path.size() - 1 or cleaned_images_path.size() == 0:
		return
	
	if not can_change_page:
		Notification.message(tr('KEY_CALM_DOWN'))
		return
	else:
		can_change_page = false
		get_tree().create_timer(0.5).timeout.connect(set_can_change_page_true)
	
	current_page += 1
	
	load_image_in_canvas()

func back() -> void:
	if current_page == 0:
		return
	
	if not can_change_page:
		Notification.message(tr('KEY_CALM_DOWN'))
		return
	else:
		can_change_page = false
		get_tree().create_timer(0.5).timeout.connect(set_can_change_page_true)
	
	current_page -= 1
	
	load_image_in_canvas()

func to_go(index : int) -> void:
	if index < 0 or index > cleaned_images_path.size() - 1:
		return
	
	if not can_change_page:
		Notification.message(tr('KEY_CALM_DOWN'))
		return
	else:
		can_change_page = false
		get_tree().create_timer(0.5).timeout.connect(set_can_change_page_true)
	
	current_page = index
	
	load_image_in_canvas()

func set_can_change_page_true() -> void:
	can_change_page = true

func load_image_in_canvas() -> void:
	if cleaned_images_path.is_empty():
		Notification.message(tr('KEY_THERE_ARE_NO_IMAGES'))
		return
	
	canvas.remove_texts()

	var filtered = app_files_images_path.filter(func(path : String): return cleaned_images_path[current_page].get_basename() == path.get_basename())
	if not filtered.is_empty():
		var path = app_files_path.path_join(filtered[0])
		var file = FileAccess.open(path, FileAccess.READ)
		var data = file.get_var()
		canvas.load(data)
	elif not boxes.is_empty() and current_page < boxes.size():
		var page = boxes[current_page]['filename']
		if page == cleaned_images_path[current_page].get_basename():
			canvas.add_boxes(boxes[current_page]['boxes'])
	
	canvas.load_cleaned_image(load_image(cleaned_path.path_join(cleaned_images_path[current_page])))
	if not raw_images_path.is_empty():
		canvas.load_raw_image(load_image(raw_path.path_join(raw_images_path[current_page])))
		
	emit_signal('page_changed')

func remove_files_non_images(files : Array) -> Array:
	return files.filter(func(file): return file.ends_with('.png') or file.ends_with('.jpg') or file.ends_with('.jpeg') or file.ends_with('.webp'))

func organize_files(files : Array) -> void:
	files.sort_custom(compare_files)

func compare_files(a : String, b : String) -> bool:
	var a_number = int(a.get_basename())
	var b_number = int(b.get_basename())
	return a_number < b_number

func load_image(path : String) -> ImageTexture:
	var image = Image.new()
	var texture = ImageTexture.new()

	image.load(path)
	texture.set_image(image)

	return texture

func set_canvas(value : SubViewportContainer) -> void:
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

func get_current_page() -> int:
	return current_page

func get_cleaned_images_path() -> Array:
	return cleaned_images_path

func _set_http_request(value : HTTPRequest) -> void:
	http_request = value
	http_request.request_completed.connect(_on_request_completed)

func _set_text_list(value : ItemList) -> void:
	text_list = value

func _exit_tree():
	canvas.clear()
	text_list.clear()
	if thread.is_started():
		thread.wait_to_finish()

func compare_files_boxes(a : Dictionary, b : Dictionary) -> bool:
	var a_number = int(a['filename'])
	var b_number = int(b['filename'])
	return a_number < b_number

func _on_request_completed(result, response_code, headers, body) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	Notification.message(tr("KEY_FINISHED_BOXES"))
	if not json.has('images'):
		return
	
	for box in json['images']:
		box['filename'] = box['filename'].get_file().get_basename()
	
	json['images'].sort_custom(compare_files_boxes)
	boxes = json['images']
