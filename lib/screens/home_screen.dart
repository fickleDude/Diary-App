import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:diary/common/appbar.dart';
import 'package:diary/common/helpers.dart';

import '../services/auth_helper.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _Menu(),
      appBar: const CustomAppBar(height: 60,),
      body: Stack(
        children: [
          getCover("assets/background/main.jpg"),
        ],
      ),
    );
  }

}

class _Menu extends StatelessWidget{

  final _authService = AuthHelper.auth;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'MEMENTO MORI',
              style: getTextStyle(25, primaryColor),
            ),
            decoration: BoxDecoration(
                color: backgroundPink,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/background/menu.jpg'))),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('PROFILE'),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.note_add_rounded),
            title: Text('MY NOTES'),
            onTap: () => context.go('/main/note_list'),
          ),
          ListTile(
            leading: Icon(Icons.notification_add_rounded),
            title: Text('MY REMINDERS'),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('SETTINGS'),
            onTap: null,
          ),
        ],
      ),
    );
  }

}