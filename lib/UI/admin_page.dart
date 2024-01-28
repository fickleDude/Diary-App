import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();

  static PageRouteBuilder getRoute() {
    return PageRouteBuilder(pageBuilder: (_, __, ___) {
      return AdminPage();
    });
  }
}

class _AdminPageState extends State<AdminPage> {
  late SharedPreferences _prefs;
  List<Map<String, String>> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsersFromPrefs();
  }

  _loadUsersFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    List<String>? userList = _prefs.getStringList('userList');
    if (userList != null) {
      setState(() {
        _users = userList.map((user) {
          List<String> parts = user.split(':');
          return {'username': parts[0], 'password': parts[1]};
        }).toList();
      });
    }
  }

  _saveUserToPrefs(String username, String password) {
    Map<String, String> user = {'username': username, 'password': password};
    _users.add(user);
    List<String> userList = _users.map((user) => '${user['username']}:${user['password']}').toList();
    _prefs.setStringList('userList', userList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Username: ${_users[index]['username']}'),
            subtitle: Text('Password: ${_users[index]['password']}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveUserToPrefs('NewUser', 'NewPassword');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
