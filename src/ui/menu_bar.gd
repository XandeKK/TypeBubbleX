extends MenuBar

var _registered_callbacks : Dictionary[String, Dictionary] = {}

func _ready() -> void:
	MenuManager.context_changed.connect(rebuild_menu)
	
	_setup_permanent_menus()
	_clear_context_menus()

func _setup_permanent_menus() -> void:
	var settings_items : Array[MenuItemConfig] = [
		MenuItemConfig.new("Preferences", _on_global_preferences_pressed)
	]
	
	var help_items : Array = [
		MenuItemConfig.new("Documentation", _on_documentation_pressed),
		MenuItemConfig.new("About TypeBubbleX", _on_about_pressed, 'f1')
	]
	
	_create_submenu("Settings", settings_items, false)
	_create_submenu("Help", help_items, false)

func _clear_context_menus() -> void:
	for child in get_children():
		if child is PopupMenu and child.has_meta("is_dynamic"):
			_registered_callbacks.erase(child.name)
			child.queue_free()

func rebuild_menu(dynamic_menu_structure : Dictionary) -> void:
	_clear_context_menus()
	
	for menu_title in dynamic_menu_structure.keys():
		_create_submenu(menu_title, dynamic_menu_structure[menu_title], true)
		
	_sort_menu_order()

func _create_submenu(menu_title : String, items : Array, is_dynamic : bool) -> void:
	var popup_menu : PopupMenu = PopupMenu.new()
	popup_menu.name = menu_title
	
	if is_dynamic:
		popup_menu.set_meta("is_dynamic", true)
	
	_registered_callbacks[menu_title] = {}
	
	for i : int in range(items.size()):
		var item : MenuItemConfig = items[i]
		item.id = i
		
		popup_menu.add_item(item.text, item.id)
		
		if item.shortcut:
			popup_menu.set_item_shortcut(popup_menu.get_item_index(item.id), item.shortcut)
		
		_registered_callbacks[menu_title][item.id] = item.callback
		
	popup_menu.id_pressed.connect(_on_item_pressed.bind(menu_title))
	add_child(popup_menu)

func _sort_menu_order() -> void:
	var permanent_menus : Array[String] = ["Settings", "Help"]
	
	for menu_name in permanent_menus:
		var menu_node = get_node_or_null(menu_name)
		if menu_node:
			move_child(menu_node, -1)

func _on_item_pressed(id : int, menu_title : String) -> void:
	if _registered_callbacks.has(menu_title) and _registered_callbacks[menu_title].has(id):
		var callback : Callable = _registered_callbacks[menu_title][id]
		
		if callback.is_valid():
			callback.call()

func _on_global_preferences_pressed() -> void:
	# to do
	pass

func _on_documentation_pressed() -> void:
	# to do
	pass

func _on_about_pressed() -> void:
	# to do
	pass
