//import 'package:flashcard_app/pages/list_flashcard.dart';
import 'package:flashcard_app/pages/halaman_auth.dart/login_screen.dart';
import 'package:flashcard_app/pages/halaman_auth.dart/register_screen.dart';
import 'package:flashcard_app/pages/splash_screen.dart';
// import 'package:flashcard_app/pages/topic_list_page.dart';
// import 'package:flashcard_app/pages/login_screen.dart';
// import 'package:flashcard_app/pages/register_screen.dart';
// import 'package:flashcard_app/pages/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        //Harus didaftarkan dulu disini
        "/": (context) => SplashScreen(),
        "/login": (context) => LoginScreenApp(),
        LoginScreenApp.id: (context) => LoginScreenApp(),
        RegisterScreenApp.id: (context) => RegisterScreenApp(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flashcard App',

      theme: ThemeData(
        // useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: TopicListPage(),
    );
  }
}
