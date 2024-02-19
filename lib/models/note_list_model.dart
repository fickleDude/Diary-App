import 'package:flutter/foundation.dart';
import 'note_model.dart';

class NoteListModel extends ChangeNotifier {
  List<NoteModel> _noteList = [NoteModel(username: 'username', title: 'title', body: 'body'),
    NoteModel(username: 'username', title: 'title', body: 'body'),
    NoteModel(username: 'username', title: 'title', body: 'body'),
    NoteModel(username: 'username', title: 'title', body: 'body')];

  set notes(List<NoteModel> newNoteList) {
    _noteList = newNoteList;
    notifyListeners();
  }
  List<NoteModel> get noteList => _noteList;

  void add(NoteModel note) {
    _noteList.add(note);
    notifyListeners();
  }

  void remove(NoteModel note) {
    _noteList.remove(note);
    notifyListeners();
  }

  void update(NoteModel noteOld, NoteModel noteNew) {
    _noteList.remove(noteOld);
    _noteList.add(noteNew);
    notifyListeners();
  }

  void pinOrUnpin(NoteModel note){
    note.isPinned = !note.isPinned;
    notifyListeners();
  }

  NoteModel getByIndex(int index){
    return _noteList[index % _noteList.length];
  }
}