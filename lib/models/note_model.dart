class NoteModel {
  final int? id;
  final String username;
  final String body;
  final String title;
  bool isPinned;


  NoteModel({
    this.id,
    required this.username,
    required this.title,
    required this.body,
    this.isPinned = false
  });

  @override
  int get hashCode => id!;

  @override
  bool operator ==(Object other) => other is NoteModel && other.username == username
                                                        && other.title == title
                                                        && other.body == body;
}