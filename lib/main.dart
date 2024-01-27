import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'UI/new_note_page.dart';
import 'UI/welcome_page.dart';

void main() async {
  // initialize firebase
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(
  //  // Replace with actual values
  //  options: FirebaseOptions(
  //    apiKey: "AIzaSyD84979B0rrV1Bqsq5vcH7C8D2tlbPHqGs",
  //    appId: "1:661084623098:android:fe62484a95066590967943",
  //    messagingSenderId: "661084623098",
  //    projectId: "diary-1b0c3",
  //  ),
  //);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: New_note_Page(),
    );
  }
}



