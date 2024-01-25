import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationLoginWidget extends StatefulWidget {
  const RegistrationLoginWidget({Key? key}) : super(key: key);

  @override
  _RegistrationLoginWidgetState createState() =>
      _RegistrationLoginWidgetState();
}

class _RegistrationLoginWidgetState extends State<RegistrationLoginWidget> {
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

  void _register() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (_prefs.getKeys().contains(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('This email is already in use'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      _prefs.setString(email, password);

      _emailController.clear();
      _passwordController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account created successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    String? storedEmail = _prefs.getString('email');
    String? storedPassword = _prefs.getString('password');

    if (email == storedEmail && password == storedPassword) {
      // Credentials are correct, allow login
      // Your further logic for successful login
      print('Login successful');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successful'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Credentials are incorrect
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid credentials'),
          duration: Duration(seconds: 2),
        ),
      );
      print('Login failed');
    }

    // Clear text fields
    _emailController.clear();
    _passwordController.clear();
  }

  void _changePassword() {
    String email = _emailController.text;
    String newPassword = _passwordController.text;

    // Проверяем, существует ли пользователь с таким email
    if (_prefs.getKeys().contains(email)) {
      _prefs.setString(email, newPassword); // Изменяем пароль

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password changed successfully'),
          duration: Duration(seconds: 2),
        ),
      );
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Memento Mori'), // Название добавлено
      ),
      body: Container(
        // Добавлен контейнер для фона с градиентом
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 210, 16, 228),
                Color.fromARGB(255, 182, 13, 13)
              ]),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _register,
                    child: Text('Register'),
                  ),
                  ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: _changePassword,
                    child: Text('Change password'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
