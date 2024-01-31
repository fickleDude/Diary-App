import 'package:diary/UI/login_page.dart';
import 'package:diary/UI/note_list_page.dart';
import 'package:flutter/material.dart';

import '../model/note.dart';
import '../utils/constants.dart';

class NotePage extends StatelessWidget {

  late double screenHeight;
  late double screenWidth;

  final Note note;

  NotePage({required this.note});

  static PageRouteBuilder getRoute({required Note note}) {
    return PageRouteBuilder(pageBuilder: (_, __, ___) {
      return NotePage(note: note);
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
        title: Text('MEMENTO MORI', style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontFamily: 'Inter',
          fontWeight: FontWeight.bold,
          height: 0,
          letterSpacing: 0.30,
        ),
    ),
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
        body: Container(
          color: backgroundPurple,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                header(note.title),
                // reminder(this.hours, this.minutes),
                body(note.body),
                backButton(context)
              ],
            ),
          ),
        ),
    );
  }

  Widget header(String title){
    return Expanded(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            width: screenWidth,
            // height: screenHeight / 4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background/note.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(title, style: TextStyle(
                          color: primaryColor,
                          fontSize: 44,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          height: 0,
                          letterSpacing: 0.30,
                        ),)
        ],
      ),
    );
  }

  Widget reminder(String? time_in_hours, String? time_in_minutes){
    return Container(
      margin: EdgeInsets.symmetric( horizontal: 16, vertical: 32),
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      width: screenWidth,
      decoration: ShapeDecoration(
        color: Color(0x7FE8E4E7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
      ),
      child:
          Text(
            time_in_hours != null && time_in_minutes != null ?
                'You added note at ${time_in_hours} : ${time_in_minutes}' :
                'No reminder set',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 0,
              letterSpacing: 0.30,
            ),
          ),
    );

  }

  Widget body(String note){
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        width: screenWidth,
        padding: const EdgeInsets.all(30),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Color(0x7FE8E4E7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child:
            SizedBox(
              child: SingleChildScrollView(
                child: Text(note, style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 0,
                  letterSpacing: -0.30,
                ),),
                scrollDirection: Axis.vertical,
              ),
            ),

      ),
    );
  }

  Widget backButton(BuildContext context){
    return Container(
      alignment: AlignmentDirectional.topStart,
      margin: EdgeInsets.only(left: 25, bottom: 16),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: primaryColor,
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: (){
            Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) {
              return NoteListPage(username: note.username);
            })
            );
          },
        ),
      ),
    );
  }
}