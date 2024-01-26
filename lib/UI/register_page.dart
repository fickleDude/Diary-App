import 'package:diary/UI/login_page.dart';
import 'package:diary/UI/note_list_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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

  void _register() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (_prefs.getKeys().contains(email)) {
      final snackbar =        SnackBar(
        content: Text('This email is already in use'),
        duration: Duration(seconds: 2),
      );
      scaffoldMessengerKey.currentState?.showSnackBar(snackbar);
    } else {
      _prefs.setString(email, password);

      _emailController.clear();
      _passwordController.clear();
      final snackbar = SnackBar(
        content: Text('Account created successfully'),
        duration: Duration(seconds: 2),
      );
      scaffoldMessengerKey.currentState?.showSnackBar(snackbar);

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
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp( //для создания графического интерфейса в стиле material design
        home: Scaffold(
            appBar: AppBar(
              title: Text('REGISTER', style: TextStyle(
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
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFB8A8C2),
                          Color(0xFFD4A6CA),
                          Color(0xFFDCA9B1),
                          Color(0xB2BB9AA0),
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
                color: Color(0xFFBB9AA0),
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
        color: Color(0xFFBB9AA0),
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
            onPressed: _register,
            child: Text('REGISTER', style: TextStyle(
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

  Widget backButton(){
    return Container(
      alignment: AlignmentDirectional.topStart,
      margin: EdgeInsets.symmetric(horizontal: 25),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Color(0xB2E8E4E7),
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

