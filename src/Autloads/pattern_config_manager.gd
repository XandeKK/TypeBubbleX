extends Node

var dirs : Array[String] : get = get_dirs, set = set_dirs
# patterns_path = [
# 'path',
# ...]
var patterns_path : Array : get = get_patterns_path, set = set_patterns_path

var filename : String = "user://patterns_configuration.cfg"

signal dirs_changed

func _ready():
	load_configuration()

func save_configuration():
	var config = ConfigFile.new()
	
	config.set_value("directories", "dirs", dirs)
	
	config.save(filename)

func load_configuration():
	var config = ConfigFile.new()
	
	var error = config.load(filename)
	
	if error == OK:
		if config.has_section_key("directories", "dirs"):
			dirs = config.get_value("directories", "dirs")
	
		scan_dirs()
	
		emit_signal('dirs_changed')

func add_dir(dir : String) -> void:
	if dirs.find(dir) != -1:
		print('already have this directory')
		return
	
	if not DirAccess.dir_exists_absolute(dir):
		print('directory does not exist')
		return
	
	dirs.append(dir)
	scan_dirs()
	emit_signal('dirs_changed')

func remove_dir(index : int) -> void:
	if index < 0 or index >= dirs.size():
		print('index out of range')
		return
	
	dirs.remove_at(index)
	scan_dirs()
	emit_signal('dirs_changed')

func scan_dirs() -> void:
	patterns_path.clear()
	
	for dir in dirs:
		scan_patterns(dir)

func scan_patterns(path : String) -> void:
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()

		while file_name != "":
			var full_path = path.path_join(file_name)

			if dir.current_is_dir():
				scan_patterns(full_path)
			elif file_name.ends_with(".png") or file_name.ends_with(".jpg") or file_name.ends_with(".jpeg") or  file_name.ends_with(".webp"):
				patterns_path.append(full_path)

			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func get_dirs() -> Array[String]:
	return dirs

func set_dirs(value : Array[String]) -> void:
	dirs = value

func get_patterns_path() -> Array:
	return patterns_path

func set_patterns_path(value : Array) -> void:
	patterns_path = value
