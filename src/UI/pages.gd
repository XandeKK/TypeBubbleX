extends HBoxContainer

@onready var pages_option = $PagesOptionButton

func _ready():
	FileHandler.pages_add.connect(pages_add)
	FileHandler.page_changed.connect(page_changed)

func _on_back_button_pressed():
	FileHandler.back()

func _on_next_button_pressed():
	FileHandler.next()

func pages_add():
	pages_option.clear()
	for item in FileHandler.cleaned_images_path:
		pages_option.add_item(item.get_file())

func page_changed():
	pages_option.select(FileHandler.current_page)

func _on_pages_option_button_item_selected(index):
	FileHandler.to_go(index)
