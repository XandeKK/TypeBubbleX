extends GutTest

class TestWithoutImages:
	extends GutTest
	
	var FileHandler = load('res://src/Autloads/file_handler.gd')
	var file_handler : FileHandler = null
	var path = 'user://tests'

	func before_each():
		file_handler = FileHandler.new()

	func after_each():
		file_handler = null
	
	func test_open():
		file_handler.open({
			'path': 'user://chapter',
			'style': Preference.HQStyles.COMIC,
			'ia': false
		})
		
		pass_test('Unable to open because there are no images')
	
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
	
	func test_set_texts_null():
		file_handler.text_list = ItemList.new()
		
		file_handler.set_texts(null)
		
		assert_eq(file_handler.text_list.item_count, 0)
	
	func test_set_texts_file_text():
		var filename = 'user://traducao.txt'
		var file = FileAccess.open(filename, FileAccess.WRITE)
		file.store_string('Querido diário\ndesculpe o erro ao digitar\nmas minha mão treme...')
		file.close()
		
		assert_file_exists(filename)
		
		file_handler.text_list = ItemList.new()
		
		file_handler.set_texts(filename)
		
		assert_true(file_handler.text_list.item_count == 3)
		
		DirAccess.remove_absolute(ProjectSettings.globalize_path(filename))
		
		assert_file_does_not_exist(filename)
	
	func test_get_current_page():
		assert_eq(file_handler.get_current_page(), 0)
	
	func test_get_cleaned_images_path():
		assert_eq(file_handler.get_cleaned_images_path(), [])
	
	func test_set_text_list():
		var item_list = ItemList.new()
		
		file_handler._set_text_list(item_list)
		
		assert_eq(file_handler.text_list, item_list)

class TestWithImages:
	extends GutTest
	
	class Canvas:
		extends SubViewportContainer
		
		var style
		
		func get_image() -> Image:
			await RenderingServer.frame_post_draw
			return Image.create(64, 64, false, Image.FORMAT_RGBA8)
		
		func load_raw_image(texture : ImageTexture) -> void:
			pass

		func load_cleaned_image(texture : ImageTexture) -> void:
			pass
		
		func remove_texts():
			pass
	
	var FileHandler = load('res://src/Autloads/file_handler.gd')
	var file_handler : FileHandler = null
	var path = 'user://chapter'
	var path_raw = path.path_join('raw')
	var path_cleaned = path.path_join('cleaned')
	var files : Array

	func create_file_image(path : String):
		var image = Image.create(64, 64, false, Image.FORMAT_RGBA8)
		image.save_png(path)

	func before_each():
		file_handler = FileHandler.new()
		
		file_handler.canvas = Canvas.new()
		
		DirAccess.make_dir_recursive_absolute(path_raw)
		DirAccess.make_dir_recursive_absolute(path_cleaned)
		
		for i in range(10):
			var filename_raw : String = path_raw.path_join(str(i) + '.png')
			var filename_cleaned : String = path_cleaned.path_join(str(i) + '.png')
			
			create_file_image(filename_raw)
			create_file_image(filename_cleaned)
			
			files.append(filename_raw)
			files.append(filename_cleaned)
		

	func after_each():
		file_handler = null
		
		for file in files:
			DirAccess.remove_absolute(ProjectSettings.globalize_path(file))
		
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path_raw))
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path_cleaned))
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	
	func open():
		file_handler.open({
			'path': path,
			'style': Preference.HQStyles.COMIC,
			'ia': false
		})
	
	func test_open():
		open()
		
		assert_eq(file_handler.cleaned_images_path.size(), 10)
		assert_eq(file_handler.raw_images_path.size(), 10)
		
		assert_eq(file_handler.canvas.style, Preference.HQStyles.COMIC)
		
	func test_process_images_cleaned():
		file_handler.cleaned_path = path_cleaned
		
		file_handler.process_cleaned_images(file_handler.cleaned_path)
		
		assert_eq(file_handler.cleaned_images_path.size(), 10)
	
	func test_process_images_raw():
		file_handler.raw_path = path_raw
		
		file_handler.process_raw_images(file_handler.raw_path)
		
		assert_eq(file_handler.raw_images_path.size(), 10)
	
	func test_save_to_file():
		open()
		
		file_handler.app_files_path = path.path_join('app_files')
		
		file_handler.save_to_file({'test': 123})
		
		assert_file_exists(file_handler.app_files_path.path_join('0.typex'))
		
		DirAccess.remove_absolute(ProjectSettings.globalize_path(file_handler.app_files_path.path_join('0.typex')))
		DirAccess.remove_absolute(ProjectSettings.globalize_path(file_handler.app_files_path))
	
	func test_update_app_file():
		open()
		
		file_handler.update_app_file()
		
		assert_eq(file_handler.app_files_images_path.size(), 1)
		assert_eq(file_handler.app_files_images_path[0], '0.typex')

	func test_save_image():
		open()
		
		var save_path = path.path_join('images')
		
		file_handler.save_image()
		await wait_seconds(0.5)
		
		assert_true(DirAccess.dir_exists_absolute(save_path))
		assert_file_exists(save_path.path_join('0.png'))
		
		DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path.path_join('0.png')))
		DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path))
		
		assert_file_does_not_exist(save_path.path_join('0.png'))
	
	func test_handler_images():
		open()
		
		var raw_image : Image = Image.create(64, 64, false, Image.FORMAT_RGBA8)
		var cleaned_image : Image = Image.create(64, 64, false, Image.FORMAT_RGBA8)
		
		var data = {
			'raw_image': raw_image,
			'cleaned_image': cleaned_image
		}
		
		file_handler.handler_images(data)
		
		assert_typeof(data.raw_image, TYPE_PACKED_BYTE_ARRAY)
		assert_typeof(data.cleaned_image, TYPE_PACKED_BYTE_ARRAY)
		assert_has(data, 'extension')
	
	func test_next():
		open()
		
		file_handler.next()
		
		assert_eq(file_handler.current_page, 1)
	
		file_handler.next()

		assert_eq(file_handler.current_page, 2)
	
	func test_back():
		open()
		
		file_handler.back()
		
		assert_eq(file_handler.current_page, 0)
		
		file_handler.current_page = 5
		
		file_handler.back()
		
		assert_eq(file_handler.current_page, 4)
	
	func test_to_go():
		open()
		
		file_handler.to_go(9)
		
		assert_eq(file_handler.current_page, 9)
	
	func test_load_image_in_canvas():
		open()
		
		watch_signals(file_handler)
		
		file_handler.load_image_in_canvas()
		
		assert_signal_emitted(file_handler, 'page_changed')
	

# I still need to test with application files, but I'm too lazy, I'll do that later
