// import 'package:diary/screens/login_screen.dart';
// import 'package:diary/screens/home_screen.dart';
// import 'package:diary/screens/note_list_screen.dart';
// import 'package:diary/screens/note_screen.dart';
// import 'package:diary/screens/register_screen.dart';
// import 'package:diary/screens/onboard_screen.dart';
// import 'package:diary/screens/splash_screen.dart';
// import 'package:diary/services/providers/auth_provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
//
// import 'common/helpers.dart';
// import 'services/providers/note_list_provider.dart';
// import 'models/note_model.dart';
//
//
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp().then((value) => print(value.name));
//   runApp(const MyApp());
// }
//
// GoRouter router() {
//   return GoRouter(
//     //default path
//     initialLocation: '/welcome',//default path
//     routes: [
//       GoRoute(
//           path: '/welcome',
//           builder: (context, state) => OnBoardScreen(),
//           routes: [
//             // /welcome/login
//             GoRoute(
//               path: 'login',
//               builder: (context, state) => const LoginScreen(),
//             ),
//             // /welcome/register
//             GoRoute(
//               path: 'register',
//               builder: (context, state) => const RegisterForm(),
//             ),
//           ]
//       ),
//       GoRoute(
//           path: '/main',
//           builder: (context, state) => HomeScreen(),
//           routes: [
//             // /main/note_list
//             GoRoute(
//               path: 'note_list',
//               builder: (context, state) => NoteList(),
//               routes: [
//                 //named path with object as parameter
//                 GoRoute(
//                     path: 'note',
//                     name: 'note',
//                     builder: (context, state){
//                       NoteModel? note = state.extra as NoteModel?; //casting is important
//                       return NoteForm(note: note);
//                     }
//                 ),
//               ],
//             ),
//           ]
//       ),
//
//     ],
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Using MultiProvider is convenient when providing multiple objects.
//     return MultiProvider(
//       providers: [
//         // Provider for note table
//         ChangeNotifierProvider(
//           // Initialize the model in the builder. That way, Provider
//           // can own Counter's lifecycle, making sure to call `dispose`
//           // when not needed anymore.
//           create: (context) => NoteListProvider(),
//         ),
//         ChangeNotifierProvider(create: (context) => AuthProvider()),
//       ],
//       builder: (context, child)=>MaterialApp(
//         title: 'MEMENTO MORI',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: backgroundPink),
//           useMaterial3: true,
//         ),
//         // routerConfig: router(),
//         home: Consumer<AuthProvider>(builder: (context, authState, _){
//           return authState.isAuthorized
//               ? const HomeScreen()
//               : FutureBuilder(
//             future: authState.tryLogin(),
//             builder: (context, snapshot) =>
//             snapshot.connectionState == ConnectionState.waiting
//                 ? const SplashScreen()
//                 : authState.displayedOnboard
//                 ? const LoginScreen()
//                 : OnBoardScreen(),
//           );
//         },),
//       ),
//     );
//   }
// }

import 'package:diary/screens/home_screen.dart';
import 'package:diary/screens/login_screen.dart';
import 'package:diary/screens/note_list_screen.dart';
import 'package:diary/screens/note_screen.dart';
import 'package:diary/screens/onboard_screen.dart';
import 'package:diary/screens/register_screen.dart';
import 'package:diary/services/providers/note_list_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'common/helpers.dart';
import 'models/note_model.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => print(value.name));
  runApp(const MyApp());
}

GoRouter router() {
  return GoRouter(
    //default path
    initialLocation: '/welcome',//default path
    routes: [
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