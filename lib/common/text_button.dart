import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'helpers.dart';

class CustomTextButton extends StatelessWidget{
  final double height; //formHeight / 16
  final double width; //formWidth / 1.2
  final String label;
  final void Function()? onPressed;

  const CustomTextButton({
    super.key,
    required this.height,
    required this.width,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: primaryColor,
        foregroundColor: primaryColor,
        fixedSize: Size( width, height),
        elevation: 4,
      ),
      onPressed: onPressed,
      child: Text(label, style: getTextStyle(16),),
    );
  }


}