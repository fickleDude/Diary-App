import 'package:cloud_firestore/cloud_firestore.dart';

class Note{
  late String title;
  late String text;
  late String time;
  late String date;
  late String username;
  late String docId;

  Note.fromDoc(QueryDocumentSnapshot doc){
    title = doc["title"];
    text = doc["text"];
    time = doc["time"];
    date = doc["date"];
    username = doc["username"];
    docId = doc.id;
  }
}