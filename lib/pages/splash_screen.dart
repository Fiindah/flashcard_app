import 'package:flashcard_app/constant/app_image.dart';
import 'package:flashcard_app/constant/app_style.dart';
import 'package:flashcard_app/helper/preference.dart';
import 'package:flashcard_app/pages/halaman_auth/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void changePage() {
    Future.delayed(Duration(seconds: 3), () async {
      bool isLogin = await PreferenceHandler.getLogin();
      print("isLogin: $isLogin");
      if (isLogin) {
        return Navigator.pushNamedAndRemoveUntil(
          context,
          LoginScreenApp.id,
          (route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          LoginScreenApp.id,
          (route) => false,
        );
      }
    });
  }

  @override
  void initState() {
    changePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            SizedBox(
              height: 150,
              width: 150,
              child: Image.asset(AppImage.logoCard),
            ),
            // SizedBox(height: 20),
            Text(
              "Flashcard App",
              style: TextStyle(
                color: Color(0xff4E71FF),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Teman Belajar Setiap Saat",
              style: TextStyle(
                color: Color(0xff4E71FF),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            SafeArea(
              child: Text("v 1.0.0", style: AppStyle.fontRegular(fontSize: 10)),
            ),
          ],
        ),
      ),
    );
  }
}
