import 'package:diary/services/data/note_list_database.dart';
import 'package:flutter/foundation.dart';
import '../../models/note_model.dart';

class NoteListProvider extends ChangeNotifier {
  List<NoteModel> _noteList = [];

  void fetchNotes() {
    //replace with search by user id
      NoteListDatabase.db.getAllNotes().then((value){
        _noteList = value;
        notifyListeners();
      });
  }
  List<NoteModel> get noteList => _noteList;

  void add(NoteModel note) {
    NoteListDatabase.db.addNote(note);
    fetchNotes();
  }

  void remove(NoteModel note) {
    NoteListDatabase.db.deleteNote(note);
    fetchNotes();
  }

  void update(NoteModel noteNew) {
    NoteListDatabase.db.updateNote(noteNew);
    fetchNotes();
  }

  void pinOrUnpin(NoteModel note){
    NoteListDatabase.db.pinOrUnpin(note);
    fetchNotes();
  }

  //to show in ListView
  NoteModel getByIndex(int index){
    return _noteList[index % _noteList.length];
  }
}