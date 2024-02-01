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
        content: content == null ? Text("") : Text(content),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(60))
        ),
        backgroundColor: primaryColor,
        titleTextStyle: getTextStyle(16),
      )
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