import 'package:diary/UI/note_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class NotePage extends StatelessWidget {

  late double screenHeight;
  late double screenWidth;
  late double screenMarging;

  final String title;
  final String note;
  final String? hours;
  final String? minutes;
  final String username;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NotePage({required this.username, required this.title, required this.note, this.hours, this.minutes});

  void _logout() {
    // Перейти на страницу входа без очистки данных для конкретного пользователя
    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  } 
  
  void _back() {
    // Перейти на страницу входа без очистки данных для конкретного пользователя
    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(
        builder: (context) => NoteListPage(username: username),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    screenMarging = (screenHeight - (screenHeight / 14 + screenHeight / 3 + 30)) / 32;

    return MaterialApp(
      navigatorKey: navigatorKey,
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
      onPressed: _logout,
      ),
    ],
    backgroundColor: Color(0xFFB8A8C2),
    ),
        body: Container(
          color: Color(0xFFB8A8C2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                header(this.title),
                reminder(this.hours, this.minutes),
                body(this.note),
                backButton()
              ],
            ),
          ),
        ),
    );
  }

  Widget header(String title){
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          width: screenWidth,
          height: screenHeight / 4,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background/note.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(title, style: TextStyle(
                        color: Color(0xB2E8E4E7),
                        fontSize: 44,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        height: 0,
                        letterSpacing: 0.30,
                      ),)
      ],
    );
  }

  Widget reminder(String? time_in_hours, String? time_in_minutes){
    return Container(
      margin: EdgeInsets.symmetric( horizontal: 8),
      alignment: Alignment.center,
      width:  3.5 * screenWidth / 4,
      height: screenHeight / 14,
      decoration: ShapeDecoration(
        color: Color(0x7FE8E4E7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
      ),
      child:
          Text(
            time_in_hours != null && time_in_minutes != null ?
                'Reminder set to ${time_in_hours} : ${time_in_minutes}' :
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
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenMarging, horizontal: 16),
      width: 3.5* screenWidth / 4,
      height: screenHeight / 3,
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
            width: 3.5 * screenWidth / 4,
            height: screenHeight / 3,
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

    );
  }

  Widget backButton(){
    return Container(
      alignment: AlignmentDirectional.topStart,
      margin: EdgeInsets.symmetric(vertical: screenMarging, horizontal: 25),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Color(0xB2E8E4E7),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: _back,
        ),
      ),
    );
  }
}