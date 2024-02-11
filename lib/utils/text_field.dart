import 'package:diary/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget{
  final TextInputType? keyboardType;
  final String? hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final String? Function(String?)? onValidate;

  CustomTextField({
    this.onValidate,
    this.hintText,
    this.controller,
    this.isPassword = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType == null ? TextInputType.name : keyboardType,
      validator: onValidate,
      obscureText: isPassword == false ? false : isPassword,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        labelText: hintText ?? 'hint text...',
        labelStyle: getTextStyle(16),
        errorStyle: getTextStyle(10),
        filled: true,
        fillColor: primaryColor,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:  BorderSide(
                style: BorderStyle.solid,
                color: primaryColor
            )
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:  BorderSide(
                style: BorderStyle.solid,
                color: primaryColor
            )
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:  BorderSide(
                style: BorderStyle.solid,
                color: primaryColor
            )
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:  BorderSide(
                style: BorderStyle.solid,
                color: primaryColor
            )
        ),
      ),
    );
  }

}