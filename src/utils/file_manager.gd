extends Node
class_name FileManager

enum Sort {
	NOTHING,
	ASCENDING_NUMERIC,
	# I don't think the three below will be necessary, but I'll leave them commented.
	#DESCENDING_NUMERIC,
	#ASCENDING_ALPHABETIC,
	#DESCENDING_ALPHABETIC
}

var error : Error
var files : Array : get = _get_files
var path : String : get = _get_path, set = _set_path
var extension : String : set = _set_extension
var regex : RegEx = RegEx.new()

func _init(_path : String, recursive : bool = false, _extension : String = "", sort : Sort = Sort.NOTHING) -> void:
	path = _path
	extension = _extension
		
	if DirAccess.dir_exists_absolute(path):
		get_files(recursive)
		sort_files(sort)
	else:
		error = Error.ERR_DOES_NOT_EXIST
		push_error("Dir does not exit")

func get_files(recursive : bool = false) -> void:
	if recursive:
		files = get_all_files(path, files)
	else:
		files = Array(DirAccess.get_files_at(path))
		filter_files()
		files = files.map(func(file : String): return path.path_join(file))

func filter_files() -> void:
	if extension.is_empty():
		return
	
	files = files.filter(func(file): return regex.search(file))

func get_all_files(_path : String, _files : Array) -> Array:
	var dir : DirAccess = DirAccess.open(_path)

	if DirAccess.get_open_error() == OK:
		dir.list_dir_begin()

		var file_name : String = dir.get_next()
		var result : RegExMatch

		while file_name != "":
			if dir.current_is_dir():
				_files = get_all_files(dir.get_current_dir().path_join(file_name), _files)
			else:
				result = regex.search(file_name)
				
				if not result:
					file_name = dir.get_next()
					continue
				
				_files.append(dir.get_current_dir().path_join(file_name))

			file_name = dir.get_next()
	else:
		error = ERR_FILE_NO_PERMISSION
		push_error("An error occurred when trying to access %s." % _path)

	return files

func sort_files(sort_custom : Sort = Sort.NOTHING) -> void:
	match sort_custom:
		Sort.NOTHING:
			return
		Sort.ASCENDING_NUMERIC:
			files.sort_custom(compare_ascending_numeric)

func compare_ascending_numeric(a : String, b : String) -> bool:
	a = a.get_file().get_basename()
	b = b.get_file().get_basename()
	
	var a_is_number : bool = a.is_valid_int()
	var b_is_number : bool = b.is_valid_int()
	
	if a_is_number and b_is_number:
		return int(a.get_basename()) < int(b.get_basename())
	elif a_is_number:
		return true
	return false

func _get_path() -> String:
	return path

func _set_path(value : String) -> void:
	path = value

func _get_files() -> Array:
	return files

func _set_extension(value : String) -> void:
	extension = value
	
	var compile_result : Error = regex.compile("\\." + extension + "$")
	
	if compile_result != OK:
		# accept all
		regex.compile(".*")
		
		error = compile_result
		push_error(error_string(error))
