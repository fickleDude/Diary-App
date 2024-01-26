import 'package:diary/UI/note_list_page.dart';
import 'package:diary/UI/register_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
  }

  Future<void> _loadCredentials() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Check if the incoming user is an administrator
    if (email == 'admin' && password == 'adminPassword') {
      // Authorization successful for administrator
      // Open the administration panel
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminPage()),
      );
    } else {
      // Остальные пользователи
      String? storedPassword = _prefs.getString(email);

      if (storedPassword != null && password == storedPassword) {
        // Credentials are correct, allow login
        // Your further logic for successful login
        print('Login successful');
        final snackbar = SnackBar(
          content: Text('Login successful'),
          duration: Duration(seconds: 2),
        );
        scaffoldMessengerKey.currentState?.showSnackBar(snackbar);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoteListPage(username: email)),
        );
      } else {
        // Credentials are incorrect
        final snackbar = SnackBar(
          content: Text('Invalid credentials'),
          duration: Duration(seconds: 2),
        );
        scaffoldMessengerKey.currentState?.showSnackBar(snackbar);
        print('Login failed');
      }
    }

    // Clear text fields
    _emailController.clear();
    _passwordController.clear();
  }

  void _register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }
  void _changePassword() {
    String email = _emailController.text;
    String newPassword = _passwordController.text;
    print(email);
// Check if a user with this email exists
    if (_prefs.getKeys().contains(email)) {
      // Now we need to check if this is a password change for the admin user
      if (email != 'admin') {
        _prefs.setString(email, newPassword); // Change the password
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password changed successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // If this is the admin user, then you need to display a message about prohibiting password changes
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Changing password for admin is not allowed here'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User is not found'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
      return MaterialApp( //для создания графического интерфейса в стиле material design
          home: Scaffold(
              appBar: AppBar(
                title: Text('LOG IN', style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  height: 0,
                  letterSpacing: 0.30,
                ),),
                backgroundColor: Color(0xFFB8A8C2),
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
            color: Color(0xB2BB9AA0),
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
            style: TextStyle(
              color: Colors.black,
              fontSize: 34,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              height: 0,
              letterSpacing: -0.30,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 14, top: 14),
          child: CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xB2E8E4E7),
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
        color: Color(0xB2BB9AA0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: "Enter your email",
              filled: true,
              fillColor: Color(0xB2E8E4E7),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xB2E8E4E7)),
                borderRadius: BorderRadius.circular(30),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xB2E8E4E7)),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              hintText: "Enter your password",
              filled: true,
              fillColor: Color(0xB2E8E4E7),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xB2E8E4E7)),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xB2E8E4E7)),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color(0xB2E8E4E7),
              foregroundColor: Color(0xB2E8E4E7),
              fixedSize: Size(
                screenWidth / 1.2,
                screenHeight / 16),
              elevation: 4,
            ),
            onPressed: _login,
            child: Text('LOG IN', style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 0,
              letterSpacing: 0.30,
            ),),
          ),
          // ElevatedButton(
          //   onPressed: _changePassword,
          //   child: Text('Change password'),
          // ),
        ],
      ),
    );
  }

  Widget changePassword(){
    TextStyle defaultStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
      height: 0,
      letterSpacing: 0.30,
    );
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

