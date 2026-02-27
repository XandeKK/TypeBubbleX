extends RefCounted

func up(db: SQLite) -> bool:
	const tables = {
		"Works": {
			"id": {"data_type": "text", "primary_key": true, "not_null": true},
			"original_title": {"data_type": "text"},
			"translated_title": {"data_type": "text"},
			"description": {"data_type": "text"},
			"type": {"data_type": "text"},
			"status": {"data_type": "text"},
			"author_artist": {"data_type": "text"}
		},
		"Covers": {
			"id": {"data_type": "text", "primary_key": true, "not_null": true},
			"work_id": {"data_type": "text", "foreign_key": "Works.id", "on_delete": "CASCADE", "not_null": true},
			"selected": {"data_type": "int", "not_null": true}
		},
		"Characters": {
			"id": {"data_type": "text", "primary_key": true, "not_null": true},
			"work_id": {"data_type": "text", "foreign_key": "Works.id", "on_delete": "CASCADE", "not_null": true},
			"original_name": {"data_type": "text"},
			"translated_name": {"data_type": "text"},
			"description": {"data_type": "text"}
		},
		"CharacterImages": {
			"id": {"data_type": "text", "primary_key": true, "not_null": true},
			"character_id": {"data_type": "text", "foreign_key": "Characters.id", "on_delete": "CASCADE", "not_null": true},
			"selected": {"data_type": "int", "not_null": true}
		},
		"CharacterNicknames": {
			"id": {"data_type": "text", "primary_key": true, "not_null": true},
			"character_id": {"data_type": "text", "foreign_key": "Characters.id", "on_delete": "CASCADE", "not_null": true},
			"nickname": {"data_type": "text"},
			"context": {"data_type": "text"}
		},
		"Chapters": {
			"id": {"data_type": "text", "primary_key": true, "not_null": true},
			"work_id": {"data_type": "text", "foreign_key": "Works.id", "on_delete": "CASCADE", "not_null": true},
			"title": {"data_type": "text"},
			"number": {"data_type": "real"},
			"language_source": {"data_type": "text"},
			"language_target": {"data_type": "text"}
		},
		"CharacterChapters": {
			"character_id": {"data_type": "text", "primary_key": true, "foreign_key": "Characters.id", "on_delete": "CASCADE", "not_null": true},
			"chapter_id": {"data_type": "text", "primary_key": true, "foreign_key": "Chapters.id", "on_delete": "CASCADE", "not_null": true}
		},
		"RawPages": {
			"id": {"data_type": "text", "primary_key": true, "not_null": true},
			"chapter_id": {"data_type": "text", "foreign_key": "Chapters.id", "on_delete": "CASCADE", "not_null": true},
			"number": {"data_type": "int"}
		},
		"CleanPages": {
			"id": {"data_type": "text", "primary_key": true, "not_null": true},
			"raw_page_id": {"data_type": "text", "foreign_key": "RawPages.id", "on_delete": "CASCADE", "not_null": true},
			"chapter_id": {"data_type": "text", "foreign_key": "Chapters.id", "on_delete": "CASCADE"}
		},
		"DonePages": {
			"id": {"data_type": "text", "primary_key": true, "not_null": true},
			"raw_page_id": {"data_type": "text", "foreign_key": "RawPages.id", "on_delete": "CASCADE", "not_null": true},
			"chapter_id": {"data_type": "text", "foreign_key": "Chapters.id", "on_delete": "CASCADE"}
		},
		"Locations": {
			"id": {"data_type": "text", "primary_key": true, "not_null": true},
			"work_id": {"data_type": "text", "foreign_key": "Works.id", "on_delete": "CASCADE", "not_null": true},
			"original_name": {"data_type": "text"},
			"translated_name": {"data_type": "text"},
			"description": {"data_type": "text"}
		},
		"LocationImages": {
			"id": {"data_type": "text", "primary_key": true, "not_null": true},
			"location_id": {"data_type": "text", "foreign_key": "Locations.id", "on_delete": "CASCADE", "not_null": true}
		},
		"LocationChapters": {
			"location_id": {"data_type": "text", "primary_key": true, "foreign_key": "Locations.id", "on_delete": "CASCADE", "not_null": true},
			"chapter_id": {"data_type": "text", "primary_key": true, "foreign_key": "Chapters.id", "on_delete": "CASCADE", "not_null": true}
		},
		"Glossaries": {
			"id": {"data_type": "text", "primary_key": true, "not_null": true},
			"work_id": {"data_type": "text", "foreign_key": "Works.id", "on_delete": "CASCADE", "not_null": true},
			"original_expression": {"data_type": "text"},
			"translated_expression": {"data_type": "text"},
			"examples": {"data_type": "text"},
			"description": {"data_type": "text"}
		},
		"GlossaryChapters": {
			"glossary_id": {"data_type": "text", "primary_key": true, "foreign_key": "Glossaries.id", "on_delete": "CASCADE", "not_null": true},
			"chapter_id": {"data_type": "text", "primary_key": true, "foreign_key": "Chapters.id", "on_delete": "CASCADE", "not_null": true}
		},
		"Bubbles": {
			"id": {"data_type": "text", "primary_key": true, "not_null": true},
			"chapter_id": {"data_type": "text", "foreign_key": "Chapters.id", "on_delete": "CASCADE", "not_null": true},
			"page_id": {"data_type": "text", "foreign_key": "RawPages.id", "on_delete": "CASCADE", "not_null": true},
			"original_text": {"data_type": "text"},
			"translated_text": {"data_type": "text"},
			"width": {"data_type": "real"},
			"height": {"data_type": "real"},
			"x": {"data_type": "real"},
			"y": {"data_type": "real"},
			"metadata": {"data_type": "text"}
		}
	}
	
	for table_name in tables.keys():
		if not db.create_table(table_name, tables[table_name]):
			return false
	return true
