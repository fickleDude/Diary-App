import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginWidget.dart';
import 'dart:convert';

class User {
  final String email;
  final String password;

  User({required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'],
      password: map['password'],
    );
  }
}

class RegistrationWidget extends StatefulWidget {
  const RegistrationWidget({Key? key}) : super(key: key);

  @override
  _RegistrationWidgetState createState() => _RegistrationWidgetState();
}

class _RegistrationWidgetState extends State<RegistrationWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _register() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Save the email and password to SharedPreferences
    _prefs.setString('email', email);
    _prefs.setString('password', password);

    // Rest of your registration logic...

    // Clear text fields
    _emailController.clear();
    _passwordController.clear();

    // Navigate to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginWidget(),
      ),
    );
  }

  List<User> _getStoredUsers() {
    String? storedUsers = _prefs.getString('users');
    if (storedUsers != null) {
      List<dynamic> decodedUsers = json.decode(storedUsers);
      return List<Map<String, dynamic>>.from(decodedUsers)
          .map((userMap) => User.fromMap(userMap))
          .toList();
    } else {
      return [];
    }
  }

  Future<void> _saveUsers(List<User> users) async {
    List<Map<String, dynamic>> userMaps =
        users.map((user) => user.toMap()).toList();
    String encodedUsers = json.encode(userMaps);
    await _prefs.setString('users', encodedUsers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
        backgroundColor: Color(0xFF4B39EF),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                blurRadius: 4, color: Color(0x33000000), offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Color(0xFF4B39EF)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF4B39EF)),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Color(0xFF4B39EF)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF4B39EF)),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF4B39EF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
