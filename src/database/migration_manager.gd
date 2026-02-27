class_name MigrationManager
extends RefCounted

const MIGRATIONS_PATH : String = "res://src/database/migrations/"

func run_migrations(db: SQLite) -> void:
	db.query("CREATE TABLE IF NOT EXISTS _Migrations (version INTEGER PRIMARY KEY);")
	
	var current_version : int = 0
	var result = db.select_rows("_Migrations", "", ["MAX(version) AS version"])
	
	if result.size() > 0 and result[0]["version"] != null:
		current_version = result[0]["version"]
	
	var migrations : Dictionary = _get_migration_scripts()
	
	for version in migrations.keys():
		if version > current_version:
			var script = migrations[version].new()
			if script.up(db):
				db.insert_row("_Migrations", {"version": version})
			else:
				printerr("Migration failed ", version)
				return

func _get_migration_scripts() -> Dictionary:
	var migration_files = DirAccess.get_files_at(MIGRATIONS_PATH)
	var migrations : Dictionary = {}
	
	var gd_files : Array[String] = []
	for f in migration_files:
		if f.ends_with(".gd") or f.ends_with(".gdc"):
			gd_files.append(f)
	
	gd_files.sort()
	
	for file_name in gd_files:
		var version = file_name.get_slice("_", 0).to_int()
		if version > 0:
			var full_path = MIGRATIONS_PATH.path_join(file_name)
			migrations[version] = load(full_path)
	
	return migrations
