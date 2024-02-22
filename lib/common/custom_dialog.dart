import 'package:diary/common/text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'helpers.dart';

class CustomDialog extends StatelessWidget{

  final String title;
  final String? content;

  CustomDialog({required this.title,required this.content});


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: content == null ? const Text("") : Text(content!, style: getTextStyle(16),),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(60))
      ),
      backgroundColor: backgroundPink,
      titleTextStyle: getTextStyle(18),
    );
  }
}