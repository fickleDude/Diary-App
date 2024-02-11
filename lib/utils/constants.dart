import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color backgroundPurple = Color(0xFFB8A8C2);
Color backgroundPink = Color(0xB2BB9AA0);
Color primaryColor = Color(0xFFE2DCDC);


dialog({required BuildContext context, required String text, String? content}){
  showDialog(context: context,
      builder: (context) =>
          AlertDialog(
        title: Text(text),
        content: content == null ? Text("") : Text(content, style: getTextStyle(16),),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(60))
        ),
        backgroundColor: backgroundPink,
        titleTextStyle: getTextStyle(18),
        actions: [
          checkButton(context)
        ],
      )
  );
}

Widget header(String title){
  return Expanded(
    child: Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          width: double.maxFinite,
          // height: screenHeight / 4,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background/note.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(title, style: getTextStyle(44, primaryColor),)
      ],
    ),
  );
}

TextStyle getTextStyle(double size, [Color color = Colors.black]) {
  return TextStyle(
    color: color,
    fontSize: size,
    fontFamily: 'Inter',
    fontWeight: FontWeight.bold,
    height: 0,
    letterSpacing: 0.30,
  );
}

  Widget checkButton(BuildContext context){
    return Container(
      alignment: AlignmentDirectional.topCenter,
      margin: EdgeInsets.only(left: 25, bottom: 16),
      child: CircleAvatar(
          radius: 30,
          backgroundColor: primaryColor,
          child: IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.black,
              ),
              onPressed: (){
                Navigator.pop(context);
              })
      ),
    );
  }
  
  Widget backButton(BuildContext context){
    return Container(
      alignment: AlignmentDirectional.topStart,
      margin: EdgeInsets.only(left: 25, bottom: 16),
      child: CircleAvatar(
          radius: 30,
          backgroundColor: backgroundPink,
          child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: (){
                Navigator.pop(context);
              })
      ),
    );
  }