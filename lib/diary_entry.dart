class DiaryEntry {
  final int id;
  final String username;
  final String date;
  final String time;
  final String text;

  DiaryEntry({
    required this.id,
    required this.username,
    required this.date,
    required this.time,
    required this.text,
  });

  // Add a named constructor to create an instance from a map
  DiaryEntry.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        username = map['username'],
        date = map['date'],
        time = map['time'],
        text = map['text'];

  // Add a method to convert the object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'date': date,
      'time': time,
      'text': text,
    };
  }
}
