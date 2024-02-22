import 'package:diary/common/custom_dialog.dart';
import 'package:diary/services/auth_ecxeption_handler.dart';
import 'package:diary/services/auth_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../common/form.dart';
import '../common/form_header.dart';
import '../common/helpers.dart';
import '../common/text_button.dart';
import '../common/text_field.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {

  late double screenHeight;
  late double screenWidth;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _authService = AuthHelper.auth;

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  //UI
  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children:[
                    getCover("assets/background/login.jpg"),
                    isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.black,))
                    : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: screenHeight / 10,),
                          CustomHeader(
                              height: screenHeight / 8,
                              width: screenWidth,
                              header: 'LOG IN'),
                          SizedBox(height: screenHeight / 16,),
                          Form(
                            key: _formKey,
                            child: CustomForm(
                                height: screenHeight / 3,
                                width: screenWidth,
                                entity: <Widget>[
                                  CustomTextField(
                                    hintText: "Enter your email",
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    isPassword: false,
                                    isFilled: true,
                                    onValidate: (email){
                                      if (email == null || email.isEmpty) {
                                        return 'Please enter email';
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
                                      }
                                      return null;
                                    },
                                  ),
                                  CustomTextButton(
                                    height: screenHeight / 16,
                                    width: screenWidth / 1.2,
                                    label: 'LOG IN',
                                    onPressed: () async{
                                      _login();
                                    },),
                                ]
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: getTextStyle(16, primaryColor),
                              children: <TextSpan>[
                                const TextSpan(text: 'Forgot your password?'),
                                TextSpan(
                                    text: ' CLICK HERE TO RESET!',
                                    style: getTextStyle(16, primaryColor,),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _resetPassword();
                                      }),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                ]

                ),
    );
  }

  //LOGIC
  void _login() async{
    setState(() { isLoading = true; });
    if(_formKey.currentState!.validate()){
      final status = await _authService.login(
          _emailController.text,
          _passwordController.text).whenComplete((){
        setState(() { isLoading = false; });
      });
      if (status == AuthStatus.successful) {
        context.go('/home');
      } else {
        showDialog(context: context,
              builder: (context) => CustomDialog(
                  title: "ERROR",
                  content: AuthExceptionHandler.generateErrorMessage(status)));
      }
    }
  }


  void _resetPassword() async{
    final status = await _authService.resetPassword(_emailController.text);
    showDialog(context: context,
        builder: (context) => CustomDialog(
            title: "CHANGE PASSWORD",
            content: AuthExceptionHandler.generateErrorMessage(status)));
  }
}

//add buttons