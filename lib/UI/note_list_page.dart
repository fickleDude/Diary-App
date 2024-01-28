import 'package:diary/UI/note_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
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

  late SharedPreferences _prefs;
  List<String> entries = [];

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
    bool isPinned1 = note1.split('\n')[6] == "false" ? false : true;
    bool isPinned2 = note2.split('\n')[6] == "false" ? false : true;
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


  Future<void> _saveEntries() async {
    await _prefs.setStringList('${widget.username}_entries', entries);
  }

  void _handleEntrySaved(String title, String content, String time_hour, String time_min, String time_day, String time_month) {
    String entry = '$title\n$content\n$time_hour\n$time_min\n$time_day\n$time_month\nfalse\n';
    if (!entries.contains(entry)) {
      setState(() {
        entries.add(entry);
        _saveEntries();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text('MOMENTO MORI', style: getTextStyle(24),),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.black,),
                  onPressed: (){
                    Navigator.push(context, LoginPage.getRoute());
                  },
                ),
              ],
              backgroundColor: backgroundPurple,
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
            String entryIsPinned = entryLines[6];
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
        Navigator.push(context, NotePage.getRoute(username: widget.username,
            title: title,
            note: note,
            hours: hours,
            minutes: minutes.length < 2 ? "0$minutes" : minutes));
      },
      child: Container(
          margin: EdgeInsets.only(top: 16, bottom: 16),
          width: noteWidth,
          height: noteHeight,
          padding: EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color:  isPinned == "false" ? backgroundPink : backgroundPurple,
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
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: SizedBox(
                  child:
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: getTextStyle(16),
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
                    style: getTextStyle(14),
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
        backgroundColor: primaryColor,
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
            showDialog(context: context,
                builder: (context) => AlertDialog(title: Text("Note deleted!")));
          },
        ),
      ),
    );
  }

  Widget pinButton(int index){
    return CircleAvatar(
      radius: 25,
      backgroundColor: primaryColor,
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
          String entryTimeDay = entryLines[4];
          String entryTimeMonth = entryLines[5];
          String entryIsPinned = entryLines[6];
          setState(() {
            // Update the UI to reflect the change in pinned status
            entries[index] = '$entryTitle\n$entryContent\n${entryTimeHour}\n${entryTimeMin}\n${entryTimeDay}\n${entryTimeMonth}'
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
      backgroundColor: backgroundPink,
      child: IconButton(
        icon: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => New_note_Page(
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
        backgroundColor: backgroundPink,
        foregroundColor: backgroundPink,
        fixedSize: Size(
            (screenWidth - 16 * 2) / 1.5,
            (screenHeight - 16 * 3) / 14.0),
        elevation: 4,
      ),
      onPressed: () async {
        int Time_min = TimeOfDay.now().minute;
        int Time_hour = TimeOfDay.now().hour;
        int Time_day = DateTime.now().day;
        int Time_mounth = DateTime.now().month;
        int count = 0;
        var list = StringBuffer();
        List<String> reminders = [];
        for (int i = 0; i < entries.length;i++){
          List<String> entryLines = entries[i].split('\n');
          String entryTitle = entryLines[0];
          String entryContent = entryLines[1];
          String entryTimeHour = entryLines[2];
          String entryTimeMin = entryLines[3];
          String entryTimeDay = entryLines[4];
          String entryTimeMounth = entryLines[5];
          var hour = int.parse(entryTimeHour);
          var min = int.parse(entryTimeMin);
          var day = int.parse(entryTimeDay);
          var mounth = int.parse(entryTimeMounth);
          if ((hour == Time_hour && min == Time_min && day == Time_day && mounth == Time_mounth) || (mounth < Time_mounth) || (hour == Time_hour && min < Time_min && day == Time_day && mounth == Time_mounth)
              || (day < Time_day && mounth == Time_mounth) || (hour < Time_hour && min == Time_min && day == Time_day && mounth == Time_mounth)){
            count++;
            reminders.add(entryTitle);
          }
        }
        reminders.forEach((item){
          list.writeln(item);
        });
        String list_ = list.toString();
        showDialog(context: context, builder: (context) =>  AlertDialog(title:Text("Number of reminders:$count", style: TextStyle(fontFamily: "Inter", fontSize: 18),),
          content: Text("$list_",style: TextStyle(fontFamily: "Inter", fontSize: 18),),));
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