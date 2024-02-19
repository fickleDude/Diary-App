import 'package:diary/screens/login_screen.dart';
import 'package:diary/screens/main_screen.dart';
import 'package:diary/screens/note_list_screen.dart';
import 'package:diary/screens/note_screen.dart';
import 'package:diary/screens/register_screen.dart';
import 'package:diary/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'common/helpers.dart';
import 'services/note_list_provider.dart';
import 'models/note_model.dart';



void main() {
  runApp(const MyApp());
}

GoRouter router() {
  return GoRouter(
    //default path
    initialLocation: '/welcome',//default path
    routes: [
      GoRoute(
          path: '/welcome',
          builder: (context, state) => WelcomeScreen(),
          routes: [
            // /welcome/login
            GoRoute(
              path: 'login',
              builder: (context, state) => const LoginForm(),
            ),
            // /welcome/register
            GoRoute(
              path: 'register',
              builder: (context, state) => const RegisterForm(),
            ),
          ]
      ),
      GoRoute(
          path: '/main',
          builder: (context, state) => MainScreen(),
          routes: [
            // /main/note_list
            GoRoute(
              path: 'note_list',
              builder: (context, state) => NoteList(),
              routes: [
                //named path with object as parameter
                GoRoute(
                    path: 'note',
                    name: 'note',
                    builder: (context, state){
                      NoteModel? note = state.extra as NoteModel?; //casting is important
                      return NoteForm(note: note);
                    }
                ),
              ],
            ),
          ]
      ),

    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Using MultiProvider is convenient when providing multiple objects.
    return MultiProvider(
      providers: [
        // Provider for note table
        ChangeNotifierProvider(
          // Initialize the model in the builder. That way, Provider
          // can own Counter's lifecycle, making sure to call `dispose`
          // when not needed anymore.
          create: (context) => NoteListProvider(),
        ),
      ],
      child: MaterialApp.router(
        title: 'MEMENTO MORI',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: backgroundPink),
          useMaterial3: true,
        ),
        routerConfig: router(),
      ),
    );
  }
}