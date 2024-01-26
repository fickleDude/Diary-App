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

  late double screenHeight;
  late double screenWidth;

  @override
  void didChangeDependencies() {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
  }

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
              title: Text('MOMENTO MORI', style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                height: 0,
                letterSpacing: 0.30,
              ),),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.black,),
                  onPressed: _logout,
                ),
              ],
              backgroundColor: Color(0xFFB8A8C2),
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
                    padding: EdgeInsets.all(20),
                    width: screenWidth,
                    height: screenHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,//vertical in row
                            children: [
                              checkRemindersButton(),
                              addNoteButton(),
                            ],
                          ),
                        ),
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
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {
            List<String> entryLines = entries[index].split('\n');
            String entryTitle = entryLines[0];
            String entryContent = entryLines[1];
            String entryTimeHour = entryLines[2];
            String entryTimeMin = entryLines[3];
            String entryIsPinned = entryLines[4];
            return drawNote(index,
                entryTitle, entryContent, entryTimeHour, entryTimeMin, entryIsPinned,
                screenHeight / 4, screenWidth);
          }
      ),
    );
  }


  Widget drawNote(int index,
      String title, String note, String hours, String minutes, String isPinned,
      double noteHeight, double noteWidth){
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
          margin: EdgeInsets.only(top: 16, bottom: 16),
          width: noteWidth,
          height: noteHeight,
          padding: EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color:  isPinned == "false" ? Color(0xB2BB9AA0) : Color(0xFFB8A8C2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // title
              Container(
                width: noteWidth,
                height: noteHeight / 4,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: Color(0xB2E8E4E7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: SizedBox(
                  child:
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0,
                        letterSpacing: 0.30,
                      ),
                    ),
                ),
              ),
              //note
              Container(
                padding: EdgeInsets.only(top: 8, left: 10),
                child: SizedBox(
                  width: noteWidth,
                  height: noteHeight / 4,
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
              ),
              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  deleteButton(index),
                  pinButton(index)
                ],
              )
            ],
          )

      ),
    );
  }

  Widget deleteButton(int index){
    return Padding(
      padding: EdgeInsets.only(right: 16),
      child: CircleAvatar(
        radius: 25,
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
      ),
    );
  }

  Widget pinButton(int index){
    return CircleAvatar(
      radius: 25,
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
      radius: (screenHeight - 16*3) / 27,
      backgroundColor: Color(0xB2BB9AA0),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Color(0xB2BB9AA0),
        foregroundColor: Color(0xB2BB9AA0),
        fixedSize: Size(
            (screenWidth - 16 * 2) / 1.5,
            (screenHeight - 16 * 3) / 14.0),
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
        fontSize: 16,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        height: 0,
        letterSpacing: 0.30,
      ),),
    );
  }



}