import 'package:flashcard_app/list_flashcard.dart';
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
      // initialRoute: "/",
      // routes: {
      //   //Harus didaftarkan dulu disini
      //   "/": (context) => SplashScreen(),
      //   "/login": (context) => LoginScreenApp(),
      //   // "/meet_2": (context) => MeetDua(),
      //   LoginScreenApp.id: (context) => LoginScreenApp(),
      //   RegisterScreenApp.id: (context) => RegisterScreenApp(),
      // },
      debugShowCheckedModeBanner: false,
      title: 'Flashcard App',

      theme: ThemeData(
        // useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ListFlashcardPage(),
    );
  }
}
