class_name BaseModel
extends RefCounted

var table_name : String = ""
var id : String = ""

func get_db_properties() -> Dictionary:
	var props : Dictionary = {}
	
	for prop in get_property_list():
		if prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE and prop.name != "table_name":
			var prop_name = prop.name
			props[prop_name] = get(prop_name)
	
	return props

func has_many(table : String, class_to_instantiate : Object, foreign_key : String) -> Array:
	var results : Array = DBClient.select_where(table, foreign_key + " = '" + id + "'")
	var list : Array = []
	
	for dict in results:
		var obj = class_to_instantiate.new()
		if obj.has_method("from_dict"):
			obj.from_dict(dict)
		list.append(obj)
		
	return list

func has_many_through(target_class: Object, join_table: String, source_fk: String, target_fk: String) -> Array:
	var target_instance : BaseModel = target_class.new()
	var target_table : String = target_instance.table_name
	
	var query = """
		SELECT t.* FROM %s t
		INNER JOIN %s j ON t.id = j.%s
		WHERE j.%s = ?
	""" % [target_table, join_table, target_fk, source_fk]
	
	var list : Array = []
	if DBClient.db.query_with_bindings(query, [id]):
		for dict in DBClient.db.query_result:
			var obj = target_class.new()
			obj.from_dict(dict)
			list.append(obj)
	return list

func belongs_to(class_to_instantiate : Object, foreign_key_id : String) -> BaseModel:
	var obj = class_to_instantiate.new()
	if obj.load_by_id(foreign_key_id):
		return obj
	return null

func from_dict(data : Dictionary) -> void:
	for key in data.keys():
		if key in self:
			set(key, data[key])

func load_by_id(target_id : String) -> bool:
	var results = DBClient.select_where(table_name, "id = '" + target_id + "'")
	
	if results.size() > 0:
		from_dict(results[0])
		return true
	
	return false

func save() -> bool:
	var data = get_db_properties()
	
	if id == "":
		id = UUID.v4()
		data["id"] = id
		return not DBClient.insert(table_name, data).is_empty()
	else:
		return DBClient.update(table_name, id, data)

func delete() -> bool:
	if id == "":
		push_warning("Attempt to delete an object without an ID (not persisted).")
		return false
	
	var success : bool = DBClient.delete(table_name, "id = '" + id + "'")
	
	if success:
		id = ""
		
	return success

func all() -> Array:
	return find_all("")

func count(column: String = "", value: Variant = null) -> int:
	var query = "SELECT COUNT(*) as total FROM " + table_name
	var results = []
	
	if column != "":
		query += " WHERE %s = ?" % column
		DBClient.db.query_with_bindings(query, [value])
	else:
		DBClient.db.query(query)
	
	results = DBClient.db.query_result
	return results[0]["total"] if results.size() > 0 else 0

func find_by(column: String, value: Variant) -> bool:
	var condition = "%s = ?" % column
	var bindings = [value]
	
	var results = DBClient.select_where_bound(table_name, condition, bindings)
	if results.size() > 0:
		from_dict(results[0])
		return true
	return false

func find_all_like(column: String, search_term: String) -> Array:
	var results : Array = DBClient.select_like_bound(table_name, column, search_term)
	var list : Array = []
	
	for dict in results:
		var obj : BaseModel = get_script().new()
		obj.from_dict(dict)
		list.append(obj)
		
	return list

func find_all(where_clause: String = "") -> Array:
	var results: Array
	if where_clause == "":
		results = DBClient.select_all(table_name)
	else:
		results = DBClient.select_where(table_name, where_clause)
	
	var list = []
	
	for dict in results:
		var obj : BaseModel = get_script().new()
		obj.from_dict(dict)
		list.append(obj)
		
	return list

func _to_string() -> String:
	var props = get_db_properties()
	var output = "\n[ %s ]" % get_class()
	output += "\n" + "—".repeat(20)
	
	for key in props.keys():
		var value = props[key]
		output += "\n %-15s : %s" % [key, str(value)]
	
	output += "\n" + "—".repeat(20)
	return output
