import 'package:diary/services/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note_model.dart';

//crud for note table
class NoteListDatabase{

  NoteListDatabase._();
  static final NoteListDatabase db = NoteListDatabase._();

  static final DatabaseHelper _helper = DatabaseHelper.db;

  Future<List<NoteModel>> getNotesByUserId(String userId) async {
    final db = await _helper.database;
    var response = await db!.rawQuery("SELECT * FROM Note WHERE userId=?;", [userId]);
    List<NoteModel> list = response.isEmpty
        ? response.map((e) => NoteModel.fromMap(e)).toList()
        : [];
    list.sort(_noteSort);
    return list;
  }

  //returns note id
  Future<int> addNote(NoteModel note) async {
    final db = await _helper.database;
    return await db!.insert("Note", note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateNote(NoteModel note) async {
    final db = await _helper.database;
    return await db!.update("Note", note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> pinOrUnpin(NoteModel note) async {
    final db = await _helper.database;
    NoteModel pinned = NoteModel(
        userId: note.userId,
        title: note.title,
        body: note.body,
        isPinned: !note.isPinned);
    return await db!
        .update("Note", pinned.toMap(), where: "id = ?", whereArgs: [note.id]);
  }

  Future<int> deleteNote(NoteModel note) async {
    final db = await _helper.database;
    return await db!.delete("Note", where: 'id = ?', whereArgs: [note.id]);
  }

  //tmp
  Future<List<NoteModel>> getAllNotes() async {
    final db = await _helper.database;

    var response = await db!.query('Note');
    List<NoteModel> list = response.isNotEmpty
        ? response.map((e) => NoteModel.fromMap(e)).toList()
        : [];
    list.sort(_noteSort);
    return list;
  }

  //to show pinned notes first
  int _noteSort(NoteModel note1, NoteModel note2) {
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