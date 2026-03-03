extends GutTest

var models_to_test = [
	{
		"class": Work, 
		"table": "Works", 
		"fields": ["original_title", "translated_title", "description", "type", "status", "author_artist"]
	},
	{
		"class": Chapter, 
		"table": "Chapters", 
		"fields": ["work_id", "title", "number", "language_source", "language_target"]
	},
	{
		"class": Character, 
		"table": "Characters", 
		"fields": ["work_id", "original_name", "translated_name", "description"]
	},
	{
		"class": Bubble, 
		"table": "Bubbles", 
		"fields": ["chapter_id", "page_id", "original_text", "translated_text", "width", "height", "x", "y", "metadata"]
	},
	{
		"class": CharacterChapter, 
		"table": "CharacterChapters", 
		"fields": ["character_id", "chapter_id"]
	},
	{
		"class": CharacterImage, 
		"table": "CharacterImages", 
		"fields": ["character_id", "selected"]
	},
	{
		"class": CharacterNickname, 
		"table": "CharacterNicknames", 
		"fields": ["character_id", "nickname", "context"]
	},
	{
		"class": CleanPage, 
		"table": "CleanPages", 
		"fields": ["raw_page_id", "chapter_id", "number"]
	},
	{
		"class": Cover, 
		"table": "Covers", 
		"fields": ["work_id", "selected"]
	},
	{
		"class": DonePage, 
		"table": "DonePages", 
		"fields": ["raw_page_id", "chapter_id", "number"]
	},
	{
		"class": Glossary, 
		"table": "Glossaries", 
		"fields": ["work_id", "original_expression", "translated_expression", "examples", "description"]
	},
	{
		"class": GlossaryChapter, 
		"table": "GlossaryChapters", 
		"fields": ["glossary_id", "chapter_id"]
	},
	{
		"class": Location, 
		"table": "Locations", 
		"fields": ["work_id", "original_name", "translated_name", "description"]
	},
	{
		"class": LocationChapter, 
		"table": "LocationChapters", 
		"fields": ["location_id", "chapter_id"]
	},
	{
		"class": LocationImage, 
		"table": "LocationImages", 
		"fields": ["location_id"]
	},
	{
		"class": RawPage, 
		"table": "RawPages", 
		"fields": ["chapter_id", "number"]
	}
]

func test_models_fields_and_tables():
	for info in models_to_test:
		var model : BaseModel = info.class.new()
		var file_name = model.get_script().get_path().get_file()
		
		assert_eq(model.table_name, info.table, "Error in %s: incorrect table name." % file_name)
		
		for field in info.fields:
			assert_true(field in model, "Error in %s: field '%s' not found." % [file_name, field])
		
		assert_true("id" in model, "Error in %s: missing 'id' property from BaseModel." % file_name)
		assert_true("table_name" in model, "Error in %s: missing 'table_name' property." % file_name)

func test_instantiation_safety():
	for info in models_to_test:
		var obj = info.class.new()
		assert_not_null(obj, "Failed to instantiate %s" % info.table)
