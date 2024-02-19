import 'package:flutter/material.dart';

Color backgroundPurple = Color(0xFFB8A8C2);
Color backgroundPink = Color(0xB2BB9AA0);
Color primaryColor = Color(0xFFE2DCDC);

TextStyle getTextStyle(double size, [Color color = Colors.black, FontWeight fontWeight = FontWeight.bold] ) {
  return TextStyle(
    color: color,
    fontSize: size,
    fontFamily: 'Inter',
    fontWeight: FontWeight.bold,
    height: 0,
    letterSpacing: 0.30,
  );
}

Widget getCover(String asset){
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(asset),
        fit: BoxFit.cover,
      ),
    ),
  );
}