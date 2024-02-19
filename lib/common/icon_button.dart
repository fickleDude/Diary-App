import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'helpers.dart';

class CustomIconButton extends StatelessWidget{
  final Icon icon;
  final void Function()? onPressed;

  const CustomIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: primaryColor,
        child: IconButton(
          icon: icon,
          onPressed: onPressed,
        ),
      ),
    );
  }

}