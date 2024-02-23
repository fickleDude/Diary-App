import 'package:diary/screens/login_screen.dart';
import 'package:diary/screens/home_screen.dart';
import 'package:diary/screens/note_list_screen.dart';
import 'package:diary/screens/note_screen.dart';
import 'package:diary/screens/profile_screen.dart';
import 'package:diary/screens/register_screen.dart';
import 'package:diary/screens/onboard_screen.dart';
import 'package:diary/screens/splash_screen.dart';
import 'package:diary/services/providers/app_user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'common/helpers.dart';
import 'services/providers/note_list_provider.dart';
import 'models/note_model.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

GoRouter router(String initialLocation) {
  return GoRouter(
    //default path
    initialLocation: initialLocation,//default path
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
          path: '/welcome',
          builder: (context, state) => OnBoardScreen(),
          routes: [
            // /welcome/login
            GoRoute(
              path: 'login',
              builder: (context, state) => const LoginScreen(),
            ),
            // /welcome/register
            GoRoute(
              path: 'register',
              builder: (context, state) => const RegisterForm(),
            ),
          ]
      ),
      GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
                path: 'profile',
                builder: (context, state) => const ProfileScreen(),
            ),
            // /home/note_list
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
        ChangeNotifierProvider(create: (context) => AppUserProvider()),
      ],
      builder: (context, child)=>Consumer<AppUserProvider>(builder: (context, authState, _){
        return FutureBuilder(
          future: authState.login(),
          builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? appSetUp('/splash')
              : authState.isAuthorized
              ? appSetUp('/home')
              : authState.displayedOnboard
              ? appSetUp('/welcome/login')
              : appSetUp('/welcome'),
        );
      },),

    );
  }

  Widget appSetUp(String initialLocation){
    return MaterialApp.router(
        title: 'MEMENTO MORI',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: backgroundPink),
          useMaterial3: true,
        ),
        routerConfig: router(initialLocation),
      );
  }
}