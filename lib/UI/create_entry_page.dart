import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import '../model/note.dart';
import '../repository/database_helper.dart';
import 'note_list_page.dart';

class New_note_Page extends StatefulWidget {
  final String username;
  final Note? note;
  const New_note_Page(this.username, this.note, {super.key});

  @override
  _New_note_Page createState() => _New_note_Page();

  static PageRouteBuilder getRoute(String username, Note? note) {
    return PageRouteBuilder(pageBuilder: (_, __, ___) {
      return New_note_Page(username, note);
    });
  }
}

class _New_note_Page extends State<New_note_Page> {
  bool isDarkMode = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      bodyController.text = widget.note!.body;
    }
  }

  Future _saveNote(DateTime dateTime) async {
    if (widget.note != null) {
      DatabaseHelper.db.updateNote(Note(
          id: widget.note!.id,
          username: widget.username,
          title: titleController.text,
          body: bodyController.text,
          isPinned: widget.note!.isPinned));
    } else {
      DatabaseHelper.db.addNote(Note(
          username: widget.username,
          title: titleController.text,
          body: bodyController.text,
          isPinned: false));
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NoteListPage(username: widget.username)));
  }

  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 25),
                      child: TextField(
                          controller: titleController,
                          style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(230, 232, 228, 231)),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "SET A TITLE",
                              hintStyle: TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(230, 232, 228, 231)),
                              filled: false)),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2.2,
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          _buildTwo(context),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 30,
                    ),
                    _buildButtons(context),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 9,
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 28),
                        child: IconButton(
                            onPressed: () {
                              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> NoteListPage(username: widget.username,)));
                            },
                            icon: Icon(Icons.arrow_back_ios,
                                color: Colors.black, size: 30))),
                  ],
                ),
              ]),
            )),
      ),
    );
  }

  /// Section Widget
  Widget _buildTwo(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: MediaQuery.of(context).size.height / 2.1,
          width: MediaQuery.of(context).size.width / 1.1,
          decoration: BoxDecoration(
            color: Color.fromARGB(125, 232, 228, 231),
            borderRadius: BorderRadius.circular(45),
          ),
          child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 25,
                  top: MediaQuery.of(context).size.height / 30),
              child: TextField(
                  controller: bodyController,
                  style: TextStyle(
                      fontFamily: "Inter", fontSize: 20, color: Colors.black),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "WRITE NOTE",
                      hintStyle: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 20,
                          color: Colors.black),
                      filled: false),
                  keyboardType: TextInputType.multiline,
                  maxLines: 10)),
        ));
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: pickDateTime,
          child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.notifications_none_outlined,
                color: Colors.black,
                size: 25,
              )),
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all<Size>(Size(
                MediaQuery.of(context).size.height / 10,
                MediaQuery.of(context).size.height / 10)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                side: BorderSide(
                    color: Color.fromARGB(230, 232, 228, 231), width: 7),
                borderRadius: BorderRadius.circular(90),
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromARGB(255, 189, 157, 164)),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        ElevatedButton(
          onPressed: () async {
            _saveNote(dateTime);
            setState(() {});
          },
          child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.save_as_outlined,
                color: Colors.black,
                size: 25,
              )),
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all<Size>(Size(
                MediaQuery.of(context).size.height / 10,
                MediaQuery.of(context).size.height / 10)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                side: BorderSide(
                    color: Color.fromARGB(230, 232, 228, 231), width: 7),
                borderRadius: BorderRadius.circular(90),
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromARGB(255, 189, 157, 164)),
          ),
        )
      ],
    );
  }

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;

    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() => this.dateTime = dateTime);
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));
  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
}
