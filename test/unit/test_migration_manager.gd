extends GutTest

var _db = null
var _manager = null

func before_each():
	_db = SQLite.new()
	_db.path = ":memory:"
	_db.open_db()
	_manager = MigrationManager.new()

func after_each():
	if _db:
		_db.close_db()

func test_initial_scheme_tables_are_created():
	_manager.run_migrations(_db)
	
	var expected_tables = ["_Migrations", "Works", "Covers", "Characters", "CharacterImages",
		"CharacterNicknames", "Chapters", "CharacterChapters", "RawPages", "CleanPages", "DonePages",
		"Locations", "LocationImages", "LocationChapters", "Glossaries", "GlossaryChapters", "Bubbles"
	]
	
	for table in expected_tables:
		_db.query("SELECT name FROM sqlite_master WHERE type='table' AND name='%s';" % table)
		assert_eq(_db.query_result.size(), 1, "A tabela %s deve ter sido criada." % table)

func test_migration_version_is_updated():
	_manager.run_migrations(_db)
	
	var result = _db.select_rows("_Migrations", "", ["MAX(version) AS version"])
	assert_eq(result[0]["version"], 1, "A versão atual no banco deve ser 1.")

func test_rerunning_migrations_does_not_fail():
	_manager.run_migrations(_db)
	_manager.run_migrations(_db)
	
	assert_engine_error_count(0, 'no engine errors')
	assert_push_error_count(0, 'no push errors')
	assert_push_warning_count(0, 'no push warnings')
