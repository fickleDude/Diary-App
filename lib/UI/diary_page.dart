// diary_page.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/Note.dart';
import 'create_entry_page.dart';
import 'login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryPage extends StatefulWidget {
  final String username;

  DiaryPage({required this.username});

  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  // late SharedPreferences _prefs;
  // List<String> entries = [];
  late Future<dynamic> entries;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // initSharedPreferences();
    setState(() {
      entries = getNotes();
    });
  }

  void alert() {
    showDialog(context: context,
        builder: (context) =>
            AlertDialog(title: Text("AA"), content: Text("fff"),));
  }

  // Future<void> initSharedPreferences() async {
  //   _prefs = await SharedPreferences.getInstance();
  //   loadEntries();
  // }

  // Future<void> loadEntries() async {
  //   List<String>? storedEntries = _prefs.getStringList('${widget.username}_entries');
  //   if (storedEntries != null) {
  //     setState(() {
  //       entries = storedEntries;
  //     });
  //   }
  // }

  Future<List<Note>> getNotes() async {
    print(widget.username);
    List<Note> notes = [];
    await FirebaseFirestore.instance
        .collection("notes")
        .get()
        .then((QuerySnapshot value) {
      value.docs.forEach((QueryDocumentSnapshot element) {
        print(element["username"].toString());
        if (widget.username.toString() == element["username"].toString()) {
          notes.add(Note.fromDoc(element));
        }
      });
    });
    return notes;
  }

  // Future<void> saveEntries() async {
  //   await _prefs.setStringList('${widget.username}_entries', entries);
  // }

  saveNotes() async {

  }

  // void handleEntrySaved(String title, String content, String time_hour, String time_min) {
  //   String entry = '$title\n$content\n$time_hour\n$time_min';
  //   if (!entries.contains(entry)) {
  //     setState(() {
  //       entries.add(entry);
  //       saveEntries();
  //     });
  //   }
  // }

  // void handleEntryDeleted(int index) {
  //   setState(() {
  //     entries.removeAt(index);
  //     saveEntries();
  //   });
  // }

  // void handleEntryEdit(int index) async {
  //   final result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => CreateEntryPage(
  //         username: widget.username,
  //         onEntrySaved: (title, content, time_hour, time_min) => handleEntryEdited(index, title, content,time_hour, time_min),
  //         initialTitle: entries[index].split('\n')[0],
  //         initialContent: entries[index].split('\n').sublist(1).join('\n'),
  //
  //       ),
  //     ),
  //   );
  //
  //   // Check if result is not null (user didn't press back)
  //   if (result != null) {
  //     // Handle the result if needed
  //     print('Entry edited: $result');
  //   }
  // }

  // void handleEntryEdited(int index, String title, String content, String time_hour, String time_min) {
  //   setState(() {
  //     entries[index] = '$title\n$content\n$time_min\n$time_hour';
  //     saveEntries();
  //   });
  // }

  // void handleEntryPinned(int index) {
  //   String entry = entries[index];
  //   List<String> entryLines = entry.split('\n');
  //   String entryTitle = entryLines[0];
  //   String entryContent = entryLines[1];
  //   String entryTimeHour = entryLines[2];
  //   String entryTimeMin = entryLines[3];
  //
  //   bool isPinned = _prefs.getBool('${widget.username}_entry_$index') ?? false;
  //
  //   // Toggle the pinned status
  //   isPinned = !isPinned;
  //
  //   _prefs.setBool('${widget.username}_entry_$index', isPinned);
  //
  //   setState(() {
  //     // Update the UI to reflect the change in pinned status
  //     entries[index] = '$entryTitle\n$entryContent\n${entryTimeHour}\n${entryTimeMin}\nPinned: $isPinned';
  //   });
  // }

  void logout() {
    // Перейти на страницу входа без очистки данных для конкретного пользователя
    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     navigatorKey: navigatorKey,
  //     home: Scaffold(
  //       appBar: AppBar(
  //         title: Text('Diary Page'),
  //         actions: [
  //           IconButton(
  //             icon: Icon(Icons.logout),
  //             onPressed: logout,
  //           ),
  //         ],
  //       ),
  //       body: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text('Welcome, ${widget.username}!'),
  //             // SizedBox(height: 20),
  //             // ElevatedButton(
  //             //   onPressed: () async {
  //             //     final result = await Navigator.push(
  //             //       context,
  //             //       MaterialPageRoute(
  //             //         builder: (context) => CreateEntryPage(
  //             //           username: widget.username,
  //             //           onEntrySaved: handleEntrySaved,
  //             //         ),
  //             //       ),
  //             //     );
  //             //
  //             //     // Check if result is not null (user didn't press back)
  //             //     if (result != null) {
  //             //       // Handle the result if needed
  //             //       print('Entry added: $result');
  //             //     }
  //             //   },
  //             //   child: Text('Add Entry'),
  //             // ),
  //             // SizedBox(height: 20),
  //             // ElevatedButton(onPressed: () async {
  //             //   int Time_min = TimeOfDay.now().minute;
  //             //   int Time_hour = TimeOfDay.now().hour;
  //             //   int count = 0;
  //             //   var list = StringBuffer();
  //             //   List<String> reminders = [];
  //             //   for (int i = 0; i < entries.length;i++){
  //             //     List<String> entryLines = entries[i].split('\n');
  //             //     String entryTitle = entryLines[0];
  //             //     String entryContent = entryLines[1];
  //             //     String entryTimeHour = entryLines[2];
  //             //     String entryTimeMin = entryLines[3];
  //             //     var hour = int.parse(entryTimeHour);
  //             //     var min = int.parse(entryTimeMin);
  //             //     if ((hour == Time_hour && min == Time_min) || (hour < Time_hour) || (hour == Time_hour && min < Time_min)){
  //             //       count++;
  //             //       reminders.add(entryTitle);
  //             //     }
  //             //   }
  //             //   reminders.forEach((item){
  //             //     list.writeln(item);
  //             //   });
  //             //   String list_ = list.toString();
  //             //   showDialog(context: context, builder: (context) =>  AlertDialog(title:Text("Number of reminders:$count"),
  //             //     content: Text("$list_"),));
  //             // }
  //             //     , child: Text("Check Reminders")),
  //             // SizedBox(height: 20),
  //             Expanded(
  //               child: ListView.builder(
  //   //                 itemCount: entries.length,
  //   //                 itemBuilder: (context, index) {
  //   //                   Note note = entries[index];
  //   //                   String entryTitle = note.title;
  //   //                   String entryContent = note.text;
  //   //                   String entryTimeHour = note.time;
  //   //                   String entryTimeMin = note.time;
  //   //                   return ListTile(
  //   //                     title: Text('Title: $entryTitle'),
  //   //                     subtitle: Column( crossAxisAlignment: CrossAxisAlignment.start ,children: [Text('Content: $entryContent'), Text('Reminder: $entryTimeHour:$entryTimeMin')]),
  //   //                     trailing: Row(
  //   //                       mainAxisSize: MainAxisSize.min,
  //   //                       children: [
  //   //                         IconButton(
  //   //                           icon: Icon(Icons.edit),
  //   //                           // onPressed: () => handleEntryEdit(index),
  //   //                           onPressed: () => null,
  //   //                         ),
  //   //                         IconButton(
  //   //                           icon: Icon(Icons.delete),
  //   //                           // onPressed: () => handleEntryDeleted(index),
  //                           onPressed: () => null,
  //                         ),
  //                         IconButton(
  //                           icon: Icon(Icons.push_pin),
  //                           // onPressed: () => handleEntryPinned(index),
  //                           onPressed: () => null,
  //                         ),
  //   )
  //                       ],
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        home: Scaffold(
          appBar: AppBar(
            title: Text('Diary Page'),
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: logout,
              ),
            ],
          ),

          body: FutureBuilder(
            future: getNotes(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return listItems(snapshot.data);
              }
              return Center(
                child: CircularProgressIndicator(strokeWidth: 3,),
              );
            },
          ),
        )
    );
  }

  Widget listItems(List<Note>? data) {
    return ListView.builder(
      itemCount: data?.length,
      itemBuilder: (context, index) {
        Note? note = data?[index];
        String? entryTitle = note?.title;
        String? entryContent = note?.text;
        String? entryTimeHour = note?.time;
        String? entryTimeMin = note?.time;
        return ListTile(
          title: Text('Title: $entryTitle'),
          subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start ,
                    children: [
                      Text('Content: $entryContent'),
                      Text('Reminder: $entryTimeHour:$entryTimeMin')
                    ]
          ),
        );
    }
    );
  }
}
