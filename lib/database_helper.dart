import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'diary_entry.dart';

class DatabaseHelper {
  static final _databaseName = 'diary_database.db';
  static final _databaseVersion = 1;

  static final tableDiary = 'diary_entries';

  static final columnId = 'id';
  static final columnUsername = 'username';
  static final columnDate = 'date';
  static final columnTime = 'time';
  static final columnText = 'text';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  late Database _database; //DATABASE INSTANCE

  //GET connection to DB
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  //create DB
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableDiary (
        $columnId INTEGER PRIMARY KEY,
        $columnUsername TEXT,
        $columnDate TEXT,
        $columnTime TEXT,
        $columnText TEXT
      )
    ''');
  }

  Future<int> insertDiaryEntry(DiaryEntry entry) async {
    final db = await database; //connect
    return await db.insert(tableDiary, entry.toMap());
  }

  Future<List<DiaryEntry>> getDiaryEntries(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableDiary,
      where: '$columnUsername = ?',
      whereArgs: [username],
    );
    return List.generate(maps.length, (i) {
      return DiaryEntry.fromMap(maps[i]);
    });
  }
}
