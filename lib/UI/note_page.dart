

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class NotePage extends StatelessWidget {
  final String title;
  final String note;
  final String? time_in_hours;
  final String? time_in_minutes;
  final String username;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NotePage({required this.username, required this.title, required this.note, this.time_in_hours, this.time_in_minutes});

  void _logout() {
    // Перейти на страницу входа без очистки данных для конкретного пользователя
    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        appBar: AppBar(
        title: Text('NOTE', style: TextStyle(
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
      icon: Icon(Icons.logout),
      onPressed: _logout,
      ),
    ],
    backgroundColor: Color(0xB2E8E4E7),
    ),
        body: Container(
          color: Color(0xFFB8A8C2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                header(this.title),
                SizedBox(height: 25,),
                reminder(this.time_in_hours, this.time_in_minutes),
                SizedBox(height: 25,),
                body(this.note),
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
          width: 392,
          height: 200,
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
      width: 338,
      height: 80,
      padding: const EdgeInsets.all(5),
      decoration: ShapeDecoration(
        color: Color(0x7FE8E4E7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            time_in_hours != null && time_in_minutes != null ?
                'Reminder set to ${time_in_hours} : ${time_in_minutes}' :
                'No reminder set',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 0,
              letterSpacing: -0.30,
            ),
          ),
        ],
      ),
    );

  }

  Widget body(String note){
    return Container(
      width: 338,
      height: 300,
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
            width: 304,
            height: 300,
            child: SingleChildScrollView(
              child: Text(note,              style: TextStyle(
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

}