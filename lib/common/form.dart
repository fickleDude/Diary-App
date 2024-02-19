import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'helpers.dart';

class CustomForm extends StatelessWidget{

  final double height; //screenHeight / 3
  final double width; //screenWidth
  final List<Widget> entity;
  final void Function()? formAction;

  const CustomForm({
    super.key,
    required this.height,
    required this.width,
    required this.entity,
    this.formAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      padding: const EdgeInsets.all(10),
      height: height,
      decoration: ShapeDecoration(
        color: backgroundPink,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: entity,
      ),
    );
  }

}