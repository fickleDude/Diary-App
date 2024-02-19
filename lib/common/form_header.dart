import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'helpers.dart';

class CustomHeader extends StatelessWidget{

  final double height; //screenHeight / 8
  final double width; //screenWidth
  final String header;

  const CustomHeader({
    super.key,
    required this.height,
    required this.width,
    required this.header});

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.topRight,
        children:[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            height: height,
            width: width,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            decoration: ShapeDecoration(
                color: backgroundPink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
            ),
            child: Text(
              header,
              textAlign: TextAlign.center,
              style: getTextStyle(40),
            ),
          ),
        ]
    );
  }

}