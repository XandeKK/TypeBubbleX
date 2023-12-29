extends GutTest

#class Canvas:
	#func get_image() -> Image:
		#return Image.new()

class TestWithoutImages:
	extends GutTest
	
	var FileHandler = load('res://src/Autloads/file_handler.gd')
	var file_handler : FileHandler = null
	var path = 'user://tests'

	func before_each():
		file_handler = FileHandler.new()

	func after_each():
		file_handler = null
	
	func test_set_paths():
		file_handler.set_paths(path)
		
		assert_eq(file_handler.cleaned_path, path.path_join('cleaned'))
		assert_eq(file_handler.raw_path, path.path_join('raw'))
		assert_eq(file_handler.app_files_path, path.path_join('app_files'))
	
	func test_process_images_cleaned():
		file_handler.cleaned_path = path.path_join('cleaned')
		
		file_handler.process_cleaned_images(file_handler.cleaned_path)
		
		assert_true(file_handler.cleaned_images_path.is_empty())
	
	func test_process_images_raw():
		file_handler.raw_path = path.path_join('raw')
		
		file_handler.process_raw_images(file_handler.raw_path)
		
		assert_true(file_handler.raw_images_path.is_empty())
	
	func test_process_app_files():
		file_handler.app_files_path = path.path_join('app_files')
		
		file_handler.process_app_files(file_handler.app_files_path)
		
		assert_true(file_handler.app_files_images_path.is_empty())
	
	func test_save_to_file():
		file_handler.app_files_path = path.path_join('app_files')
		
		file_handler.save_to_file({'test': 123})
		
		pass_test('Unable to save file because there are no images')
	
	func test_update_app_file():
		file_handler.update_app_file()
		
		pass_test('Unable to update app file because there are no images')
	
	func test_save_image():
		var save_path = path.path_join('images')
		
		file_handler.save_image()
		
		assert_false(DirAccess.dir_exists_absolute(save_path))
	
	func test_handler_images():
		file_handler.handler_images({'test': 123})
		
		pass_test('Unable to handle images because there are no images')
	
	func test_get_image_extension_png():
		var extension : String = file_handler.get_image_extension('querido_diário.png')
		
		assert_eq(extension, 'png')
	
	func test_get_image_extension_jpg():
		var extension : String = file_handler.get_image_extension('querido_diário.jpg')
		
		assert_eq(extension, 'jpg')
	
	func test_get_image_extension_jpeg():
		var extension : String = file_handler.get_image_extension('querido_diário.jpeg')
		
		assert_eq(extension, 'jpg')
	
	func test_get_image_extension_webp():
		var extension : String = file_handler.get_image_extension('querido_diário.webp')
		
		assert_eq(extension, 'webp')
	
	func test_get_image_extension_invalid():
		var extension : String = file_handler.get_image_extension('querido_diário.error')
		
		assert_eq(extension, '')
	
	func test_load_image_in_canvas():
		file_handler.load_image_in_canvas()
		
		pass_test('Unable to load images in canvas because there are no images')
	
	func test_next():
		file_handler.next()
		
		assert_eq(file_handler.current_page, 0)
	
	func test_back():
		file_handler.back()
		
		assert_eq(file_handler.current_page, 0)
	
	func test_to_go():
		file_handler.to_go(10)
		
		assert_eq(file_handler.current_page, 0)
	
	func test_remove_files_non_images_only_non_images():
		var files = file_handler.remove_files_non_images(['0.cpp', '1.h', '2'])
		
		assert_true(files.is_empty())
	
	func test_remove_files_non_images():
		var files = file_handler.remove_files_non_images(['0.cpp', '1.png', '2.h', '3.jpg', '4', '5.webp', '6.jpeg'])
		
		assert_eq(files, ['1.png', '3.jpg', '5.webp', '6.jpeg'])
	
	func test_compare_files_is_less():
		var is_less : bool = file_handler.compare_files('0.png', '10.png')
		
		assert_true(is_less)
	
	func test_compare_files_is_not_less():
		var is_less : bool = file_handler.compare_files('10.png', '0.png')
		
		assert_false(is_less)
	
	func test_organize_files():
		var files = ['10.png', '5.png', '0.png', '20.png', '2.png']
		
		file_handler.organize_files(files)
		
		assert_eq(files, ['0.png', '2.png', '5.png', '10.png', '20.png'])
	
	func test_set_canvas():
		var canvas : SubViewportContainer = SubViewportContainer.new()
		file_handler.canvas = canvas
		
		assert_eq(file_handler.canvas, canvas)
	
	# falta testar set_texts, get_current_page, get_cleaned_images_path e _set_text_list

class TestWithImages:
	extends GutTest
	
	var FileHandler = load('res://src/Autloads/file_handler.gd')
	var file_handler = null

	func before_each():
		file_handler = FileHandler.new()

	func after_each():
		file_handler = null

class TestWithImagesAndLoad:
	extends GutTest
	
	var FileHandler = load('res://src/Autloads/file_handler.gd')
	var file_handler = null

	func before_each():
		file_handler = FileHandler.new()

	func after_each():
		file_handler = null
