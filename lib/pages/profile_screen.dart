import 'package:flashcard_app/constant/app_color.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profil Aplikasi",
          style: TextStyle(fontSize: 18),
        ), // Display topic name
        foregroundColor: Colors.white,
        backgroundColor: AppColor.myblue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage("assets/images/foto.jpg"),
                backgroundColor: Colors.indigoAccent,
              ),
              const SizedBox(height: 20),
              buildContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Container buildContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'Flashcard App',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColor.myblue,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Aplikasi flashcard ini digunakan untuk membantu proses belajar dan menghafal.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Divider(height: 30, thickness: 1),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Dibuat oleh:', style: TextStyle(fontSize: 16)),
              Text('Endah FN', style: TextStyle(fontSize: 16)),
            ],
          ),
          Divider(height: 30, thickness: 1),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Versi:', style: TextStyle(fontSize: 16)),
              Text('1.0.0', style: TextStyle(fontSize: 16)),
            ],
          ),
          Divider(height: 30, thickness: 1),
        ],
      ),
    );
  }
}

/**
 * import 'package:flutter/material.dart';

class ProfilApp extends StatelessWidget {
  const ProfilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: const Text('Profil Aplikasi'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage("assets/images/foto.jpg"),
                backgroundColor: Colors.indigoAccent,
              ),
              const SizedBox(height: 20),
              buildContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Container buildContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'FlutterApp',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Aplikasi ini dibuat untuk memenuhi tugas mobile programming dengan Flutter.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Divider(height: 30, thickness: 1),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Dibuat oleh:', style: TextStyle(fontSize: 16)),
              Text('Endah FN', style: TextStyle(fontSize: 16)),
            ],
          ),
          Divider(height: 30, thickness: 1),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Versi:', style: TextStyle(fontSize: 16)),
              Text('1.0.0', style: TextStyle(fontSize: 16)),
            ],
          ),
          Divider(height: 30, thickness: 1),
        ],
      ),
    );
  }
}
 */
