import 'package:flashcard_app/constant/app_color.dart';
import 'package:flashcard_app/constant/app_image.dart';
import 'package:flashcard_app/constant/app_style.dart';
import 'package:flashcard_app/helper/preference.dart';
import 'package:flashcard_app/pages/login_screen.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 0;
  static const List<Widget> _screen = [
    // Center(child: Text("Halaman 1")),
    // // Meet14a(),
    // // Meet14b(),
    // // Center(child: Text("Halaman 2")),
    // // Meet12AInputWidget(),
    // Center(child: Text("Halaman 3")),
  ];
  void _itemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print("Halaman saat ini : $_selectedIndex");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Menu Drawer")),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColor.myblue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(AppImage.foto),
                  ),
                  Text(
                    "Endah Fitria",
                    style: AppStyle.fontRegular(fontSize: 16),
                  ),
                  Text(
                    "endahfitri@gmail.com",
                    style: AppStyle.fontBold(fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: AppColor.myblue),
              title: Text("Home", style: AppStyle.fontRegular(fontSize: 14)),
              onTap: () {
                _itemTapped(0);
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.home, color: AppColor.myblue),
              title: Text(
                "List dan Map",
                style: AppStyle.fontRegular(fontSize: 14),
              ),
              onTap: () {
                _itemTapped(1);
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.key, color: AppColor.myblue),
              title: Text(
                "Validator",
                style: AppStyle.fontRegular(fontSize: 14),
              ),
              onTap: () {
                _itemTapped(2);
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: AppColor.orange),
              title: Text("Keluar", style: AppStyle.fontRegular(fontSize: 14)),
              onTap: () {
                PreferenceHandler.deleteLogin();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreenApp()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: _screen[_selectedIndex],
    );
  }
}
