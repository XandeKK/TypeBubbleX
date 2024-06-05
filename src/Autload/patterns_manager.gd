extends Node

var directories : Array[String] : get = get_directories, set = set_directories
var images : Dictionary : get = get_images, set = set_images

var filename : String = "user://patterns_configuration.cfg"

signal directories_changed

func _ready():
	load_configuration()

func save_configuration():
	var config = ConfigFile.new()
	
	config.set_value("directories", "directories", directories)
	config.set_value("images", "images", images)
	
	config.save(filename)

func load_configuration():
	var config = ConfigFile.new()
	
	var error = config.load(filename)
	
	if error == OK:
		if config.has_section_key("directories", "directories"):
			directories = config.get_value("directories", "directories")
	
		scan_directories()
		
		if config.has_section_key("images", "images"):
			images = config.get_value("images", "images")
	
		emit_signal('directories_changed')

func add_directory(directory : String) -> void:
	if directories.find(directory) != -1:
		Notification.message(tr('KEY_ALREADY_HAVE_THIS_DIRECTORY'))
		return
	
	if not DirAccess.dir_exists_absolute(directory):
		Notification.message(tr('KEY_DIRECTORY_DOES_NOT_EXIST'))
		return
	
	directories.append(directory)
	scan_directories()
	emit_signal('directories_changed')

func remove_directory(index : int) -> void:
	if index < 0 or index >= directories.size():
		Notification.message(tr('KEY_INDEX_OUT_OF_RANGE'))
		return
	
	directories.remove_at(index)
	scan_directories()
	emit_signal('directories_changed')

func scan_directories() -> void:
	for dir in directories:
		scan_images(dir)

func scan_images(path : String) -> void:
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()

		while file_name != "":
			var full_path = path.path_join(file_name)

			if dir.current_is_dir():
				scan_images(full_path)
			elif file_name.ends_with(".jpg") or file_name.ends_with(".png") or file_name.ends_with(".jpeg") or file_name.ends_with(".webp") or file_name.ends_with(".svg"):
				images[full_path] = null

			file_name = dir.get_next()
	else:
		Notification.call_deferred('message', "Patterns Managed: An error occurred when trying to access the path.")

func get_directories() -> Array[String]:
	return directories

func set_directories(value : Array[String]) -> void:
	directories = value

func get_images() -> Dictionary:
	return images

func set_images(value : Dictionary) -> void:
	images = value
