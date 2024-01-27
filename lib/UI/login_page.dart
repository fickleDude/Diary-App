import 'package:diary/UI/note_list_page.dart';
import 'package:diary/UI/register_page.dart';
import 'package:diary/utils/text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import 'admin_page.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();

  static PageRouteBuilder getRoute() {
    return PageRouteBuilder(pageBuilder: (_, __, ___) {
      return LoginPage();
    });
  }

}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late SharedPreferences _prefs;

  late double screenHeight;
  late double screenWidth;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    //ADMIN
    if (email == 'admin' && password == 'adminPassword') {
      // Authorization successful for administrator
      // Open the administration panel
      Navigator.push(
        context,
        AdminPage.getRoute(),
      );
    }
    // USERS
    else {
      String? storedPassword = _prefs.getString(email);
      //CORRECT
      if (storedPassword != null && password == storedPassword) {
        dialog(context: context, text: 'Login successful');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoteListPage(username: email)),
        );
      }
      //INCORRECT
      else if(storedPassword == null) {
        dialog(context: context, text: 'User ${email} not found');
      }
      else{
        dialog(context: context, text: 'Wrong credentials');
      }
    }

    //CLEAR
    _emailController.clear();
    _passwordController.clear();
  }

  void _register() {
    Navigator.push(
      context,
      RegisterPage.getRoute(),
    );
  }

  void _changePassword() {
    String email = _emailController.text;
    String newPassword = _passwordController.text;

    //ADMIN
    if(email == 'admin'){
      dialog(context: context, text:'Changing password for admin is not allowed here');
    }
    //USER EXISTS
    else if (_prefs.getKeys().contains(email)){
      _prefs.setString(email, newPassword); // Change the password
      dialog(context:context, text:'Password changed successfully');
    }
    //USER DOESN'T EXISTS
    else{
      dialog(context:context, text:'User ${email} not found');
    }
  }

  @override
  Widget build(BuildContext context) {
      screenHeight = MediaQuery.of(context).size.height;
      screenWidth = MediaQuery.of(context).size.width;
      return MaterialApp(
          home: Scaffold(
              appBar: AppBar(
                title: Text('LOG IN', style: getTextStyle(24),),
                backgroundColor: backgroundPurple,
              ),
              body: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/background/log_in.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Scaffold(
                    backgroundColor: Colors.transparent,
                    body: SingleChildScrollView(
                      child: Container(
                        width: screenWidth,
                        height: screenHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            header(),
                            signInBox(),
                            changePassword(),
                            SizedBox(height: screenHeight * 0.45,)
                          ],
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
                onPressed: _register,
              ),
          ),
        )
    ]
      );
  }

  Widget signInBox(){
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
          ),
          CustomTextField(
            hintText: "Enter your password",
            controller: _passwordController,
            isPassword: true,
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
            onPressed: _login,
            child: Text('LOG IN', style: getTextStyle(16),),
          ),
        ],
      ),
    );
  }

  Widget changePassword(){
    TextStyle defaultStyle = getTextStyle(16);
    TextStyle linkStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontFamily: 'Inter',
      fontWeight: FontWeight.bold,
      height: 0,
      letterSpacing: 0.30,
    );
    return RichText(
      text: TextSpan(
        style: defaultStyle,
        children: <TextSpan>[
          TextSpan(text: 'Forgot your password?'),
          TextSpan(
              text: ' CLICK HERE TO RESET!',
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _changePassword();
                }),
        ],
      ),
    );
  }
}

