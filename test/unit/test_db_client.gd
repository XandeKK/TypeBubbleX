extends GutTest

var test_table : String = "Works"
var data : Dictionary = {
	"id": UUID.v4(),
	"original_title": "One piece",
	"translated_title": "One piece",
	"description": "It follows the adventures of Monkey D. Luffy and his crew, the Straw Hat Pirates, as he explores the Grand Line in search of the mythical treasure known as the \"One Piece\" to become the next King of the Pirates.",
	"type": "Manga",
	"status": "Ongoing",
	"author_artist": "Eiichiro Oda"
}

var data_1 : Dictionary = {
	"id": UUID.v4(),
	"original_title": "Detective Conan",
	"translated_title": "Case Closed",
	"description": "The story follows the high school detective Shinichi Kudo, whose body was transformed into that of an elementary school-age child while investigating a mysterious organization.",
	"type": "Manga",
	"status": "Ongoing",
	"author_artist": "Gosho Aoyama"
}

func before_each() -> void:
	DBClient.open_db(":memory:")

func after_each() -> void:
	if DBClient.db:
		DBClient.db.close_db()

func test_open_db_connection() -> void:
	assert_not_null(DBClient.db, "Database instance should be initialized")
	assert_eq(DBClient.db_path, ":memory:", "Database path should be memory-resident")

func test_insert_data() -> void:
	var result_id : String = DBClient.insert(test_table, data)
	
	assert_eq(result_id, data.id, "Insert should return the ID of the record")
	
	var records : Array = DBClient.select_all(test_table)
	assert_eq(records.size(), 1, "There should be exactly one record in the table")
	assert_eq(records[0]["original_title"], "One piece", "Data integrity check failed")

func test_insert_failure_returns_empty_string():
	var result : String = DBClient.insert("invalid_table", {"name": "error"})
	assert_engine_error_count(1)
	assert_eq(result, "", "Should return an empty string on database failure")

func test_update_data() -> void:
	DBClient.insert(test_table, data)
	
	var update_data : Dictionary = {"translated_title": "Uma peça"}
	var success : bool = DBClient.update(test_table, data.id, update_data)
	
	assert_true(success, "Update operation should return true")
	var result : Array = DBClient.select_where(test_table, "id = '" + data.id + "'")
	assert_eq(result[0]["translated_title"], "Uma peça", "The name column was not updated correctly")

func test_select_where_bound() -> void:
	DBClient.insert(test_table, data)
	DBClient.insert(test_table, data_1)
	
	var results : Array = DBClient.select_where_bound(test_table, "author_artist = ?", ["Eiichiro Oda"])
	
	assert_eq(results.size(), 1, "Should find only one work")
	assert_eq(results[0]["author_artist"], "Eiichiro Oda", "Binding should have returned Oda")

func test_select_like_bound() -> void:
	DBClient.insert(test_table, data)
	DBClient.insert(test_table, data_1)
	
	var results : Array = DBClient.select_like_bound(test_table, "author_artist", "Oda")
	
	assert_eq(results.size(), 1, "Search should find 'Oda'")
	assert_true("Oda" in results[0]["author_artist"], "Result should contain the word Oda")

func test_select_no_results():
	var results = DBClient.select_where_bound(test_table, "author_artist = ?", ["Non-existent Author"])
	assert_true(results is Array, "Result should be an Array")
	assert_eq(results.size(), 0, "Array should be empty when no matches are found")

func test_delete_data() -> void:
	DBClient.insert(test_table, data)
	
	var success : bool = DBClient.delete(test_table, "id = '" + data.id + "'")
	
	assert_true(success, "Delete operation should return true")
	var size : int = DBClient.count(test_table)
	assert_eq(size, 0, "Table should be empty after deletion")

func test_sql_injection_resilience() -> void:
	DBClient.insert(test_table, data)
	
	var malicious_id = data.id + "' OR '1'='1"
	var malicious_update = {"translated_title": "Hacked"}
	
	DBClient.update(test_table, malicious_id, malicious_update)
	
	var all_data : Array = DBClient.select_all(test_table)
	assert_ne(all_data[0]["translated_title"], "Hacked", "Update should not be vulnerable to simple SQL injection")

func test_foreign_key_constraint():
	DBClient.insert(test_table, data)
	
	var result : String = DBClient.insert('Covers', {'id': UUID.v4(), 'work_id': "Not exist", 'selected': true})
	assert_engine_error_count(1)
	assert_eq(result, "", "Should fail to insert due to foreign key constraint")

func test_unicode_storage():
	var emoji_data = data.duplicate()
	emoji_data.id = UUID.v4()
	emoji_data.original_title = "One Piece 🏴‍☠️ 🔥"
	emoji_data.translated_title = "ワンピース"
	
	DBClient.insert(test_table, emoji_data)
	var result = DBClient.select_where(test_table, "id = '" + emoji_data.id + "'")
	
	assert_eq(result[0]["original_title"], "One Piece 🏴‍☠️ 🔥", "Falha ao salvar Emojis")
	assert_eq(result[0]["translated_title"], "ワンピース", "Falha ao salvar caracteres não-ASCII")

class TestFileDatabase:
	extends GutTest
	var test_table : String = "Works"
	var data : Dictionary = {"id": UUID.v4(),"original_title": "One piece"}
	var real_path : String = "user://test_persistent.db"
	
	func before_each() -> void:
		DBClient.open_db(real_path)

	func after_each() -> void:
		if DBClient.db:
			DBClient.db.close_db()
			var dir : DirAccess = DirAccess.open("user://")
			dir.remove("test_persistent.db")
	
	func test_persistence_between_sessions():
		DBClient.insert(test_table, data)
		DBClient.db.close_db()
		
		DBClient.open_db(real_path)
		var results = DBClient.select_all(test_table)
		assert_eq(results.size(), 1, "Data should persist after closing and reopening the file")
