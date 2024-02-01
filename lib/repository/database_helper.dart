import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/note.dart';

//SIGLETON
class DatabaseHelper {
  //приватный конструктор, который можно вызвать только внутри класса
  DatabaseHelper._();
  //статическая константа, создается единожды при инициализации класса, но доступна извне
  static final DatabaseHelper db = DatabaseHelper._();

  //use _ for private variables
  static Database? _database;
  //implement lazy init with getter
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  static Future<Database> initDB() async {
    String sql = "CREATE TABLE Note("
        "id INTEGER PRIMARY KEY,"
        "username TEXT,"
        "title TEXT,"
        "body TEXT,"
        "isPinned INTEGER);";
    String path = join(await getDatabasesPath(), 'diary.db');
    return await openDatabase(path, version: 1, onOpen: (db){},
        onCreate: (Database db, int version) async {
      await db.execute(sql);
      version = 1;
    });
  }

  Future<int> addNote(Note note) async {
    final db = await database;
    return await db!.insert("Note", note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db!.update("Note", note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> pinOrUnpin(Note note) async {
    final db = await database;
    Note pinned = Note(
        username: note.username,
        title: note.title,
        body: note.body,
        isPinned: !note.isPinned);
    return await db!
        .update("Note", pinned.toMap(), where: "id = ?", whereArgs: [note.id]);
  }

  Future<int> deleteNote(Note note) async {
    final db = await database;
    return await db!.delete("Note", where: 'id = ?', whereArgs: [note.id]);
  }

  void dropTable() async {
    final db = await database;
    db!.rawQuery("drop table Note");
  }

  Future<List<Note>?> getNotesByUsername(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db!.rawQuery("SELECT * FROM Note WHERE username=?;", [username]);
    if (maps.isEmpty) {
      return null;
    }
    List<Note>? res =
        List.generate(maps.length, (index) => Note.fromMap(maps[index]));
    res.sort(_noteSort);
    return res;
  }

  Future<Note?> getLastNoteByUsername(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db!.rawQuery("SELECT * FROM Note WHERE username=? ORDER BY ID DESC;", [username]);
    if (maps.isEmpty) {
      return null;
    }
    List<Note>? res =
        List.generate(maps.length, (index) => Note.fromMap(maps[index]));
    res.sort(_noteSort);
    return res.first;
  }

  Future<List<Note>?> getAllNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('Note');
    if (maps.isEmpty) {
      return null;
    }
    List<Note>? res =
        List.generate(maps.length, (index) => Note.fromMap(maps[index]));
    res.sort(_noteSort);
    return res;
  }

  int _noteSort(Note note1, Note note2) {
    bool isPinned1 = note1.isPinned;
    bool isPinned2 = note2.isPinned;
    if (isPinned1 && !isPinned2) {
      return -1;
    } else if (!isPinned1 && isPinned2) {
      return 1;
    } else {
      return 0;
    }
  }
}
