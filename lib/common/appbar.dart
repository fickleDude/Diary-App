import 'package:diary/services/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            await _logout().then((value)
            => context.go('/welcome/login'));
        }
        ),
      ],
      backgroundColor: backgroundPink,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);

  Future<void> _logout() async{
    await AuthHelper.auth.logout();
  }
}