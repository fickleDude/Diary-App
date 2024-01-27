import 'package:diary/UI/login_page.dart';
import 'package:diary/UI/note_list_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import '../utils/text_field.dart';
import 'admin_page.dart';

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

  //form validator
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late SharedPreferences _prefs;

  late double screenHeight;
  late double screenWidth;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _register() {
    final FormState? form = _formKey.currentState;
    if (!form!.validate()){
      return;
    }
    String email = _emailController.text;
    String password = _passwordController.text;
    //USER EXISTS
    if (_prefs.getKeys().contains(email)) {
      dialog(context: context, text: 'This email is already in use');
    }
    //USER DOES NOT EXIST
    else {
      _prefs.setString(email, password);

      _emailController.clear();
      _passwordController.clear();
      dialog(context: context, text: 'Account created successfully');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NoteListPage(username: email)),
      );
    }
  }

  void _back() {
    // Перейти на страницу входа без очистки данных для конкретного пользователя
    Navigator.push(
      context,
      LoginPage.getRoute(),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp( //для создания графического интерфейса в стиле material design
        home: Scaffold(
            appBar: AppBar(
              title: Text('REGISTER', style: getTextStyle(24),),
              backgroundColor: backgroundPurple,
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
                      child: Padding(
                        padding: EdgeInsets.only(top: 24, bottom: 24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              header(),
                              SizedBox(height: screenHeight * 0.07),
                              registerBox(),
                              SizedBox(height: screenHeight * 0.19),
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
      height: screenHeight / 3,
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
            hintText: "Enter your email",
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            isPassword: false,
            onValidate: (email){
              if(email!.isEmpty || email.length < 3 || !email.contains("@")){
                return 'enter correct email';
              }
              return null;
            },
          ),
          CustomTextField(
            hintText: "Enter your password",
            controller: _passwordController,
            isPassword: true,
            onValidate: (password){
              if(password!.isEmpty || password.length < 3){
                return 'enter correct password';
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
            onPressed: _register,
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
          onPressed: _back,
        ),
      ),
    );
  }
}

