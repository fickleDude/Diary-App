import 'package:diary/UI/note_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'create_entry_page.dart';
import 'login_page.dart';

class NoteListPage extends StatefulWidget {
  final String username;

  NoteListPage({required this.username});

  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {

  late SharedPreferences _prefs;
  List<String> entries = [];
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadEntries();
  }

  int _noteSort(String note1, String note2){
    bool isPinned1 = note1.split('\n')[4] == "false" ? false : true;
    bool isPinned2 = note2.split('\n')[4] == "false" ? false : true;
    if(isPinned1 && !isPinned2){
      return -1;
    }else if(!isPinned1 && isPinned2){
      return 1;
    }else{
      return 0;
    }
  }

  Future<void> _loadEntries() async {
    List<String>? storedEntries = _prefs.getStringList('${widget.username}_entries');
    if (storedEntries != null) {
      setState(() {
        entries = storedEntries;
        entries.sort(_noteSort);
      });
    }
  }

  void _logout() {
    // Перейти на страницу входа без очистки данных для конкретного пользователя
    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  Future<void> _saveEntries() async {
    await _prefs.setStringList('${widget.username}_entries', entries);
  }

  void _handleEntrySaved(String title, String content, String time_hour, String time_min) {
    String entry = '$title\n$content\n$time_hour\n$time_min\nfalse\n';
    if (!entries.contains(entry)) {
      setState(() {
        entries.add(entry);
        _saveEntries();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        home: Scaffold(
            appBar: AppBar(
              title: Text('ALL NOTES', style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                height: 0,
                letterSpacing: 0.30,
              ),),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: _logout,
                ),
              ],
              backgroundColor: Color(0xB2E8E4E7),
            ),
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/background/notes_list.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            checkRemindersButton(),
                            SizedBox(width: 40,),
                            addNoteButton(),
                          ],
                        ),
                        SizedBox(height: 10,),
                        drawNotesList()
                      ],
                    ),
                  ),
                ),
              ],
            )
        )
    );
  }

  Widget drawNotesList(){
    return Expanded(
      child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {
            List<String> entryLines = entries[index].split('\n');
            String entryTitle = entryLines[0];
            String entryContent = entryLines[1];
            String entryTimeHour = entryLines[2];
            String entryTimeMin = entryLines[3];
            String entryIsPinned = entryLines[4];
            return drawNote(index, entryTitle, entryContent, entryTimeHour, entryTimeMin, entryIsPinned);
          }
      ),
    );
  }


  Widget drawNote(int index, String title, String note, String hours, String minutes, String isPinned){
    return InkWell(
      onTap: (){
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
            builder: (context) => NotePage(username: widget.username, title: title,note: note,
              hours : hours,
              minutes: minutes),
          ),
        );
      },
      child: Container(
          margin: EdgeInsets.only(left: 8, right: 8, top: 40, bottom: 20),
          width: 338,
          height: 200,
          padding: const EdgeInsets.all(15),
          decoration: ShapeDecoration(
            color:  isPinned == "false" ? Color(0xB2BB9AA0) : Color(0xFFB8A8C2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 308,
                height: 40,
                padding: const EdgeInsets.all(10),
                decoration: ShapeDecoration(
                  color: Color(0xB2E8E4E7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0,
                        letterSpacing: 0.30,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                height: 50,
                child: Text(
                  note.length > 100 ? note.replaceRange(100, note.length, '...') : note,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 0.30,
                  ),
                ),
              ),
              SizedBox(height: 11,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  deleteButton(index),
                  SizedBox(width: 10,),
                  pinButton(index)
                ],
              )
            ],
          )

      ),
    );
  }

  Widget deleteButton(int index){
    return CircleAvatar(
      radius: 27,
      backgroundColor: Color(0xB2E8E4E7),
      child: IconButton(
        icon: Icon(
          Icons.delete,
          color: Colors.black,
        ),
        onPressed: (){
          setState(() {
            entries.removeAt(index);
            _saveEntries();
          });
          showDialog(context: context, builder: (context) =>  AlertDialog(title:Text("Note deleted!"),));
        },
      ),
    );
  }

  Widget pinButton(int index){
    return CircleAvatar(
      radius: 27,
      backgroundColor: Color(0xB2E8E4E7),
      child: IconButton(
        icon: Icon(
          Icons.push_pin,
          color: Colors.black,
        ),
        onPressed: (){
          String entry = entries[index];
          List<String> entryLines = entry.split('\n');
          String entryTitle = entryLines[0];
          String entryContent = entryLines[1];
          String entryTimeHour = entryLines[2];
          String entryTimeMin = entryLines[3];
          String entryIsPinned = entryLines[4];
          //_prefs.setBool('${widget.username}_entry_$index', entryIsPinned == "false" ? true : false);

          setState(() {
            // Update the UI to reflect the change in pinned status
            entries[index] = '$entryTitle\n$entryContent\n${entryTimeHour}\n${entryTimeMin}'
                '\n${entryIsPinned == "false" ? "true" : "false"}\n';
            _prefs.setStringList('${widget.username}_entries', entries);
            entries.sort(_noteSort);
          });
        },
      ),
    );
  }

  Widget addNoteButton(){
    return CircleAvatar(
      radius: 27,
      backgroundColor: Color(0xB2E8E4E7),
      child: IconButton(
        icon: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateEntryPage(
                username: widget.username,
                onEntrySaved: _handleEntrySaved,
              ),
            ),
          );

          // Check if result is not null (user didn't press back)
          if (result != null) {
            // Handle the result if needed
            print('Entry added: $result');
          }
        },
      ),
    );
  }

  Widget checkRemindersButton(){
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        backgroundColor: Color(0xB2BB9AA0),
        foregroundColor: Color(0xB2BB9AA0),
        fixedSize: Size(250, 45),
        // padding: EdgeInsets.all(4),
        elevation: 4,
      ),
      onPressed: () async {
        int Time_min = TimeOfDay.now().minute;
        int Time_hour = TimeOfDay.now().hour;
        int count = 0;
        var list = StringBuffer();
        List<String> reminders = [];
        for (int i = 0; i < entries.length;i++){
          List<String> entryLines = entries[i].split('\n');
          String entryTitle = entryLines[0];
          String entryTimeHour = entryLines[2];
          String entryTimeMin = entryLines[3];
          var hour = int.parse(entryTimeHour);
          var min = int.parse(entryTimeMin);
          if ((hour == Time_hour && min == Time_min) || (hour < Time_hour) || (hour == Time_hour && min < Time_min)){
            count++;
            reminders.add(entryTitle);
          }
        }
        reminders.forEach((item){
          list.writeln(item);
        });
        String list_ = list.toString();
        showDialog(context: context, builder: (context) =>  AlertDialog(title:Text("Number of reminders:$count"),
          content: Text("$list_"),));
      },
      icon: const Icon(Icons.remove_red_eye, color: Colors.black,),
      label: const Text('CHECK REMINDERS', style: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        height: 0,
        letterSpacing: 0.30,
      ),),
    );
  }



}