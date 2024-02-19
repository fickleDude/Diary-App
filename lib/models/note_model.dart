class NoteModel {
  final int? id;
  final String userId;
  final String body;
  final String title;
  bool isPinned;


  NoteModel({
    this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.isPinned = false
  });

  //named constructor "fromMap"
  //creates an instance from json
  //фабричный конструктор позволяет выполнить доп логику перед созданием объекта
  factory NoteModel.fromMap(Map<String, dynamic> json) => NoteModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
      isPinned: json['isPinned'] == 0 ? false : true
  );

  //method converts the object to a map
  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'title': title,
    'body': body,
    'isPinned': isPinned ? 1 : 0
  };
}