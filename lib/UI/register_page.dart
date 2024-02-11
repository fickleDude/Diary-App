import 'dart:async';
import 'package:diary/UI/login_page.dart';
import 'package:diary/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/text_field.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();

  static PageRouteBuilder getRoute() {
    return PageRouteBuilder(pageBuilder: (_, __, ___) {
      return RegisterPage();
    });
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  //form validator - identify the state of form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //circular indicator
  bool isLoading = false;

  late double screenHeight;
  late double screenWidth;

  Future<void> _register() async {
    //check if fields are valid
    if (!_formKey.currentState!.validate()){
      return;
    }

    setState(() { isLoading = true; });

    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text)
        .then((userCredentials)
        {
          userCredentials.user?.updateDisplayName(_usernameController.text);
          Navigator.push(context, LoginPage.getRoute());
        })
        .catchError((error){
          if(error is FirebaseAuthException){
            if (error.code == 'weak-password') {
              dialog(context: context, text: "AUTHENTICATION ERROR",content: 'The password provided is too weak');
            } else if (error.code == 'email-already-in-use') {
              dialog(context: context, text: "AUTHENTICATION ERROR",content: 'The account already exists for that email');
            }else{
              dialog(context: context, text: "AUTHENTICATION ERROR",content: error.code);
            }
          }else{
            dialog(context: context, text: "ERROR",content: error.toString());
          }
        },)
      .whenComplete(() => setState(() { isLoading = false; }));
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp( //для создания графического интерфейса в стиле material design
        home: Scaffold(
            appBar: AppBar(
              title: Text('MEMENTO MORI', style: getTextStyle(24),),
              backgroundColor: primaryColor,
            ),
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          backgroundPurple,
                          Color(0xFFD4A6CA),
                          Color(0xFFDCA9B1),
                          backgroundPink,
                        ]),
                  ),
                ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    child: Container(
                      width: screenWidth,
                      height: screenHeight,
                      child:  Padding(
                        padding: EdgeInsets.only(top: 24, bottom: 24),
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator(
                          color: Colors.black,
                        )
                        )
                            : Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              header(),
                              SizedBox(height: screenHeight * 0.05),
                              registerBox(),
                              SizedBox(height: screenHeight * 0.1),
                              backButton()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
        )
    );
  }

  Widget header(){
    return Stack(
        alignment: Alignment.topRight,
        children:[
          Container(
            margin: EdgeInsets.only(left: 20, right: 20,top: 8),
            height: screenHeight / 9,
            width: screenWidth,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 60),
            decoration: ShapeDecoration(
                color: backgroundPink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  )
                ]
            ),
            child: Text(
              'MEMENTO\n MORI',
              textAlign: TextAlign.center,
              style: getTextStyle(34),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 14, top: 14),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: primaryColor,
              child: IconButton(
                icon: Icon(Icons.person_add_alt_rounded, size: 32,),
                color: Colors.black,
                onPressed: null,
              ),
            ),
          )
        ]
    );
  }

  Widget registerBox(){
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20,top: 8),
      padding: EdgeInsets.all(16),
      height: screenHeight / 2.3,
      decoration: ShapeDecoration(
        color: backgroundPink,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomTextField(
            hintText: "Enter your username",
            controller: _usernameController,
            keyboardType: TextInputType.name,
            isPassword: false,
            onValidate: (username){
              if(username!.isEmpty){
                return 'Username is empty'; //error message shown on our text field
              }
              return null;//if all conditions satisfied
            },
          ),
          CustomTextField(
            hintText: "Enter your email",
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            isPassword: false,
            onValidate: (email){
              if(email!.isEmpty || email.length < 3
                  || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)){
                return 'Email malformed';
              }
              return null;
            },
          ),
          CustomTextField(
            hintText: "Enter your password",
            controller: _passwordController,
            isPassword: true,
            onValidate: (password){
              if(password!.isEmpty || password.length < 6){
                return 'Password too weak';
              }
              return null;
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: primaryColor,
              foregroundColor: primaryColor,
              fixedSize: Size(
                  screenWidth / 1.2,
                  screenHeight / 16),
              elevation: 4,
            ),
            onPressed: () async{
              await _register();
            },
            child: Text('REGISTER', style: getTextStyle(16),),
          ),
        ],
      ),
    );
  }

  Widget backButton(){
    return Container(
      alignment: AlignmentDirectional.topStart,
      margin: EdgeInsets.symmetric(horizontal: 25),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: primaryColor,
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed:(){
            Navigator.pop(context);
          }
        ),
      ),
    );
  }
}

