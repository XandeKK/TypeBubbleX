extends Node

var db : SQLite
var db_path : String = ""
var verbosity_level : int = SQLite.NORMAL

func open_db(_db_path : String) -> void:
	db_path = _db_path
	_connect_to_db()

func _connect_to_db() -> void:
	db = SQLite.new()
	db.path = db_path
	db.verbosity_level = verbosity_level
	db.foreign_keys = true
	
	if db.open_db():
		var migrations : MigrationManager = MigrationManager.new()
		migrations.run_migrations(db)
	else:
		printerr("Critical error: Unable to open database.")

func insert(table_name : String, data : Dictionary) -> String:
	if db.insert_row(table_name, data):
		return data.get("id", "")
	return ""

func update(table_name : String, id : String, data : Dictionary) -> bool:
	var condition = 'id = "' + str(id) + '"'
	return db.update_rows(table_name, condition, data)

func count(table_name : String, condition : String = "") -> int:
	var query : String = "SELECT COUNT(*) as total FROM %s" % table_name
	if condition != "":
		query += " WHERE %s" % condition
	
	if db.query(query):
		return int(db.query_result[0].get("total", 0))
	return 0

func select_all(table_name : String) -> Array:
	return db.select_rows(table_name, "", ["*"])

func select_where(table_name : String, condition : String) -> Array:
	return db.select_rows(table_name, condition, ["*"])

func select_where_bound(table_name : String, condition : String, bindings : Array) -> Array:
	var query : String = "SELECT * FROM %s WHERE %s;" % [table_name, condition]
	if db.query_with_bindings(query, bindings):
		return db.query_result
	return []

func select_like_bound(table_name : String, column : String, search_term : String) -> Array:
	var query : String = "SELECT * FROM %s WHERE %s LIKE ?;" % [table_name, column]
	var formatted_search : String = "%" + search_term + "%"
	
	if db.query_with_bindings(query, [formatted_search]):
		return db.query_result
	return []

func delete(table_name : String, condition : String) -> bool:
	return db.delete_rows(table_name, condition)

func _exit_tree() -> void:
	if db:
		db.close_db()
