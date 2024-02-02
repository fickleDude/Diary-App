// '{ "name": "Pizza da Mario", "cuisine": "Italian" }'
import 'dart:convert';

class Note {
  final int? id;
  final String username;
  final String body;
  final String title;
  final bool isPinned;


  Note({
    this.id,
    required this.username,
    required this.title,
    required this.body,
    this.isPinned = false
  });

  //named constructor "fromMap"
  //creates an instance from json
  //фабричный конструктор позволяет выполнить доп логику перед созданием объекта
  factory Note.fromMap(Map<String, dynamic> json) => Note(
      id: json['id'],
      username: json['username'],
      title: json['title'],
      body: json['body'],
      isPinned: json['isPinned'] == 0 ? false : true
  );

  //converts the object to a map
  Map<String, dynamic> toMap() => {
    'username': username,
    'title': title,
    'body': body,
    'isPinned': isPinned ? 1 : 0
  };

  static String toJsonString(Note note){
    // type: dynamic (runtime type: _InternalLinkedHashMap<String, dynamic>)
    final parsedNote = note.toMap();
    // type: Note
    return jsonEncode(parsedNote);
  }

  static Note toNote(String jsonData){
    // type: dynamic (runtime type: _InternalLinkedHashMap<String, dynamic>)
    final parsedJson = jsonDecode(jsonData);
    // type: Note
    return Note.fromMap(parsedJson);
  }

}
