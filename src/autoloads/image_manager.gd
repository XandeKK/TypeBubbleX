extends Node

var base_path : String : set = set_base_path

func _get_file_path(uuid : String) -> String:
	var prefix : String = uuid.substr(0, 2)
	var filename : String = uuid + ".png"
	return base_path.path_join(prefix).path_join(filename)

func set_base_path(_base_path : String) -> void:
	base_path = _base_path
	
	if not DirAccess.dir_exists_absolute(base_path):
		DirAccess.make_dir_absolute(base_path)

func has_image(uuid : String) -> bool:
	if uuid.is_empty():
		return false
	
	var path : String = _get_file_path(uuid)
	return FileAccess.file_exists(path)

func load_from_uuid(uuid : String) -> Texture2D:
	var path : String = _get_file_path(uuid)
	
	if path.is_empty() or not FileAccess.file_exists(path):
		return null
		
	var img : Image = Image.new()
	var error : Error = img.load(path)
	
	if error == OK and not img.is_empty():
		return ImageTexture.create_from_image(img)
		
	return null

func load_from_path(external_path : String) -> Texture2D:
	if external_path.is_empty() or not FileAccess.file_exists(external_path):
		return null
		
	var img : Image = Image.new()
	var error : Error = img.load(external_path)
	
	if error != OK:
		img = _recover_image_with_wrong_extension(external_path)
	
	if img and not img.is_empty():
		return ImageTexture.create_from_image(img)
		
	return null

func _recover_image_with_wrong_extension(path : String) -> Image:
	var file : FileAccess = FileAccess.open(path, FileAccess.READ)
	if not file:
		return null
		
	var file_length : int = file.get_length()
	if file_length < 4:
		file.close()
		return null
		
	var header : PackedByteArray = file.get_buffer(12)
	var header_size : int = header.size()
	
	var is_png : bool = header_size >= 4 and header[0] == 0x89 and header[1] == 0x50 and header[2] == 0x4E and header[3] == 0x47
	var is_jpg : bool = header_size >= 3 and header[0] == 0xFF and header[1] == 0xD8 and header[2] == 0xFF
	var is_webp : bool = header_size >= 12 and \
				   header[0] == 0x52 and header[1] == 0x49 and header[2] == 0x46 and header[3] == 0x46 and \
				   header[8] == 0x57 and header[9] == 0x45 and header[10] == 0x42 and header[11] == 0x50

	if not (is_png or is_jpg or is_webp):
		file.close()
		return null
	
	file.seek(0)
	var buffer : PackedByteArray = file.get_buffer(file_length)
	file.close()
	
	var recovered_img := Image.new()
	var err := OK
	
	if is_png:
		err = recovered_img.load_png_from_buffer(buffer)
	elif is_jpg:
		err = recovered_img.load_jpg_from_buffer(buffer)
	elif is_webp:
		err = recovered_img.load_webp_from_buffer(buffer)
		
	if err == OK:
		return recovered_img
		
	return null

func save_image(img : Image, uuid : String) -> bool:
	if uuid.is_empty() or not img or img.is_empty():
		return false
		
	var dest_path : String = _get_file_path(uuid)
	var dir_path : String = dest_path.get_base_dir()
	
	if not DirAccess.dir_exists_absolute(dir_path):
		var err : Error = DirAccess.make_dir_absolute(dir_path)
		if err != OK:
			return false
		
	var error : Error = img.save_png(dest_path)
	return error == OK

func delete_image(uuid : String) -> bool:
	if not has_image(uuid):
		return false
		
	var path : String = _get_file_path(uuid)
	var error : Error = DirAccess.remove_absolute(path)
	
	return error == OK
