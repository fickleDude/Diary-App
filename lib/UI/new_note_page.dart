import 'package:flutter/material.dart';
import 'diary_page.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
//import 'note_list_page.dart';

class New_note_Page extends StatefulWidget {
  final String username;
  final void Function(String title, String content, String time_hour, String time_min, String time_day, String time_month) onEntrySaved;
  final String? initialTitle;
  final String? initialContent;


  const New_note_Page({
    Key? key,
    required this.username,
    required this.onEntrySaved,
    this.initialTitle,
    this.initialContent,

  }) : super(key: key);

  @override
  _New_note_Page createState() => _New_note_Page();
}

class _New_note_Page extends State<New_note_Page> {
  bool isDarkMode = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialTitle != null) {
      titleController.text = widget.initialTitle!;
    }
    if (widget.initialContent != null) {
      contentController.text = widget.initialContent!;
    }
  }

  Future<void> _saveEntry(DateTime datetime) async {
    String fileName = 'diary_entries_${widget.username}.txt';
    final file = await _localFile(fileName);
    String entryTitle = titleController.text;
    String entryContent = contentController.text;

    await file.writeAsString('$entryTitle\n$entryContent\n${datetime.hour}\n${datetime.minute}\n${datetime.day}\n${datetime.month}\n\n', mode: FileMode.append);

    // Pass entry data back to the previous screen
    widget.onEntrySaved(entryTitle, entryContent, datetime.hour.toString(), datetime.minute.toString(), datetime.day.toString(), datetime.month.toString());
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> NoteListPage()));
  }

  Future<File> _localFile(String fileName) async {
    final path = await getApplicationDocumentsDirectory();
    return File('${path.path}/$fileName');
  }
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/new_note.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 30,
            ),
            child: Stack(children: [
              Positioned(bottom: 180, left: MediaQuery.of(context).size.width/2.1, child:_buildButtons(context),
            ), Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(left:MediaQuery.of(context).size.width/25), child:
                TextField(controller: titleController, style: TextStyle(fontFamily: "Inter", fontSize: 40, fontWeight: FontWeight.bold, color: Color.fromARGB(230, 232, 228, 231)),
                    decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "SET A TITLE",
                    hintStyle: TextStyle(fontFamily: "Inter", fontSize: 40, fontWeight: FontWeight.bold, color: Color.fromARGB(230, 232, 228, 231)),
                    filled: false
                )),),
                SizedBox(
                  height: MediaQuery.of(context).size.height/2,
                  width: MediaQuery.of(context).size.width/1.1,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      _buildTwo(context),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/28, top:MediaQuery.of(context).size.height/4.35), child:
                IconButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> NoteListPage()));
                }, icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 30))),
                SizedBox(height: 10),
              ],
            ),]
          ),)
        ),
      ),
    );
  }


  /// Section Widget
  Widget _buildTwo(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: MediaQuery.of(context).size.height/2,
        width: MediaQuery.of(context).size.width/1.1,
        decoration: BoxDecoration( color: Color.fromARGB(125, 232, 228, 231),
          borderRadius: BorderRadius.circular(45),
        ),
        child: Padding(padding: EdgeInsets.only(left:MediaQuery.of(context).size.width/25, top:MediaQuery.of(context).size.height/30), child:
        TextField(controller: contentController, style:TextStyle(fontFamily: "Inter", fontSize: 20, color: Colors.black), decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "WRITE NOTE",
            hintStyle: TextStyle(fontFamily: "Inter", fontSize: 20, color: Colors.black),
            filled: false),
          keyboardType: TextInputType.multiline,
          maxLines: 10
        )
      ),)
    );
  }
  Widget _buildButtons(BuildContext context){
    return Row( mainAxisAlignment: MainAxisAlignment.end,
      children: [
      ElevatedButton(onPressed: pickDateTime,
        child: Align( alignment: Alignment.center,
            child: Icon(Icons.notifications_none_outlined, color: Colors.black, size: 35,)),
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.height/8, MediaQuery.of(context).size.height/8)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              side: BorderSide(color: Color.fromARGB(230, 232, 228, 231), width: 7),
              borderRadius: BorderRadius.circular(90),
            ),
          ), backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 189, 157, 164)),
        ),),
      SizedBox(width: 10,),
      ElevatedButton(onPressed: (){_saveEntry(dateTime);},
        child: Align( alignment: Alignment.center,
            child: Icon(Icons.save_as_outlined, color: Colors.black, size: 35,)),
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.height/8, MediaQuery.of(context).size.height/8)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              side: BorderSide(color: Color.fromARGB(230, 232, 228, 231), width: 7),
              borderRadius: BorderRadius.circular(90),
            ),
          ), backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 189, 157, 164)),
        ),)
    ],);
  }
  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;

    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute
    );
    setState(() =>this.dateTime = dateTime);
}
  Future<DateTime?> pickDate() => showDatePicker(context: context, initialDate: dateTime, firstDate: DateTime(1900), lastDate: DateTime(2100));
  Future<TimeOfDay?> pickTime() => showTimePicker(context: context, initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
}
