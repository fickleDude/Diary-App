import 'package:diary/services/auth_helper.dart';
import 'package:diary/services/providers/app_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'helpers.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final double height;

  const CustomAppBar({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('MEMENTO MORI', style: getTextStyle(24),),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.black,),
          onPressed: () async{
            await AuthHelper.auth.logout().whenComplete(() async {
              // set userinfo to null, will rebuild the consumer in main.dart
              context.read<AppUserProvider>().logout();

              // then clear the user info from local storage
              final preferences = await SharedPreferences.getInstance();
              await preferences.remove(userKey);
            });
        }
        ),
      ],
      backgroundColor: backgroundPink,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}