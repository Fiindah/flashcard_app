import 'package:flashcard_app/constant/app_color.dart';
import 'package:flashcard_app/constant/app_image.dart';
import 'package:flashcard_app/constant/app_style.dart';
import 'package:flashcard_app/database/db_helper.dart';
import 'package:flashcard_app/helper/preference.dart';
import 'package:flashcard_app/model/topic_model.dart';
import 'package:flashcard_app/pages/halaman_auth.dart/login_screen.dart';
import 'package:flashcard_app/pages/list_flashcard.dart'; // Import ListFlashcardPage
import 'package:flashcard_app/pages/profile_page.dart';
import 'package:flutter/material.dart';

class TopicListPage extends StatefulWidget {
  const TopicListPage({super.key});

  @override
  State<TopicListPage> createState() => _TopicListPageState();
}

class _TopicListPageState extends State<TopicListPage> {
  List<Topic> _topics = [];
  final TextEditingController _newTopicController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  @override
  void dispose() {
    _newTopicController
        .dispose(); // Dispose the controller to prevent memory leaks
    super.dispose();
  }

  void _loadTopics() async {
    final data = await DbHelper.getAllTopics();
    setState(() {
      _topics = data;
    });
  }

  void _showAddTopicDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Topik Baru'),
          content: TextField(
            controller: _newTopicController,
            decoration: const InputDecoration(hintText: 'Nama Topik'),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                _newTopicController.clear();
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Tambah'),
              onPressed: () async {
                final topicName = _newTopicController.text.trim();
                if (topicName.isNotEmpty) {
                  final newTopic = Topic(name: topicName);
                  await DbHelper.insertTopic(newTopic);
                  _newTopicController.clear();
                  _loadTopics(); // Reload topics to update the UI
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Deletes a topic from the database and reloads the list
  void _deleteTopic(int topicId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Topik?'),
          content: const Text(
            'Menghapus topik ini juga akan menghapus semua flashcard di dalamnya. Lanjutkan?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                await DbHelper.deleteTopic(topicId); // Delete topic from DB
                _loadTopics(); // Reload topics
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  int _selectedIndex = 0;
  final List<Widget> _screen = [TopicListPage(), ProfilePage()];

  void _itemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print("Halaman saat ini : $_selectedIndex");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.neutral,
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
                    style: TextStyle(fontSize: 16, color: AppColor.neutral),
                  ),
                  Text(
                    "endah12@gmail.com",
                    style: TextStyle(fontSize: 16, color: AppColor.neutral),
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
              leading: Icon(Icons.person, color: AppColor.myblue),
              title: Text(
                "Profil Aplikasi",
                style: AppStyle.fontRegular(fontSize: 14),
              ),
              onTap: () {
                _itemTapped(1);
                // Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
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
            // _screen.elementAt(_selectedIndex),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Flashcard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: AppColor.myblue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              top: 20.0,
              bottom: 8.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Text(
              "Welcome to Flashcard App",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColor.myblue, // Using your app color
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SizedBox(
              width: 300,
              child: Text(
                "Buat dan kuasai setiap materi pembelajaran dengan aplikasi flashcard yang mudah digunakan.",
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child:
                _topics.isEmpty
                    ? const Center(
                      child: Text(
                        'Belum ada topik. Tambahkan topik baru!',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _topics.length,
                      itemBuilder: (context, index) {
                        final topic = _topics[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 4.0,
                          ),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            title: Text(
                              topic.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColor.myblue,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTopic(topic.id!),
                            ),
                            onTap: () {
                              // Navigate to the ListFlashcardPage for this topic
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ListFlashcardPage(
                                        selectedTopic: topic,
                                      ),
                                ),
                              ).then(
                                (_) => _loadTopics(),
                              ); // Reload topics when returning
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTopicDialog,
        label: const Text('Tambah Topik'),
        icon: const Icon(Icons.add),
        // backgroundColor: Theme.of(context).primaryColor,
        backgroundColor: AppColor.myblue,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
