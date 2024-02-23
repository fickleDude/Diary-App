import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:diary/common/form.dart';
import 'package:diary/common/form_header.dart';
import 'package:diary/common/helpers.dart';
import 'package:diary/common/text_button.dart';
import 'package:diary/common/text_field.dart';

import '../common/custom_dialog.dart';
import '../services/auth_ecxeption_handler.dart';
import '../services/auth_helper.dart';

class RegisterForm extends StatefulWidget{
  const RegisterForm({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterFormState();
}


class _RegisterFormState extends State<RegisterForm> {

  late double screenHeight;
  late double screenWidth;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _authService = AuthHelper.auth;

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repasswordController.dispose();
  }

  //UI
  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return  Stack(
      children: [

        Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              getCover("assets/background/register.jpg"),
              isLoading
              ?const Center(child: CircularProgressIndicator(color: Colors.black,))
              : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight / 10,),
                    CustomHeader(
                        height: screenHeight / 8,
                        width: screenWidth,
                        header: 'REGISTER'),
                    SizedBox(height: screenHeight / 16,),
                    Form(
                      key: _formKey,
                      child: CustomForm(
                          height: screenHeight / 2,
                          width: screenWidth,
                          entity: <Widget>[
                            CustomTextField(
                              hintText: "Enter your name",
                              controller: _usernameController,
                              keyboardType: TextInputType.name,
                              isPassword: false,
                              isFilled: true,
                              onValidate: (username){
                                if (username == null || username.isEmpty) {
                                  return 'Please fill your name';
                                }
                                return null;
                              },
                            ),
                            CustomTextField(
                              hintText: "Enter your email",
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              isPassword: false,
                              isFilled: true,
                              onValidate: (email){
                                if (email == null || email.isEmpty) {
                                  return 'Please enter email';
                                }else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)){
                                  return 'Please correct malformed email';
                                }
                                return null;
                              },
                            ),
                            CustomTextField(
                              hintText: "Enter your password",
                              controller: _passwordController,
                              isPassword: true,
                              isFilled: true,
                              onValidate: (password){
                                if (password == null || password.isEmpty) {
                                  return 'Please enter password';
                                } else if (password.length < 6){
                                  return 'Please create stronger password';
                                }
                                return null;
                              },
                            ),
                            CustomTextField(
                              hintText: "Retype your password",
                              controller: _repasswordController,
                              isPassword: true,
                              isFilled: true,
                              onValidate: (repassword){
                                if (repassword == null || repassword.isEmpty) {
                                  return 'Please retype password';
                                } else if (repassword != _passwordController.text){
                                  return 'Please retype password correctly';
                                }
                                return null;
                              },
                            ),
                            CustomTextButton(
                              height: screenHeight / 16,
                              width: screenWidth / 1.2,
                              label: 'REGISTER',
                              onPressed: () async{
                                _register();
                              },),
                          ]
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )

        ),
      ],
    );
  }

  //LOGIC
  void _register() async{
    setState(() { isLoading = true; });
    if(_formKey.currentState!.validate()){
      final status = await _authService.register(
          _emailController.text,
          _passwordController.text,
          _usernameController.text).whenComplete((){
        setState(() { isLoading = false; });
      });
      if (status == AuthStatus.successful) {
        //never show on boarding screen again
        final preferences= await SharedPreferences.getInstance();
        await preferences.setBool(isStoredKey, true);
        context.go('/welcome/login');
      } else {
        showDialog(context: context,
            builder: (context) => CustomDialog(
                title: "ERROR",
                content: AuthExceptionHandler.generateErrorMessage(status)));
      }
    }
  }
}