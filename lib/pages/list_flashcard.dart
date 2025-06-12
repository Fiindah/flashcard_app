import 'package:flashcard_app/constant/app_color.dart';
import 'package:flashcard_app/database/db_helper.dart';
import 'package:flashcard_app/model/flashcard_model.dart';
import 'package:flashcard_app/model/topic_model.dart'; // Import the Topic model
import 'package:flashcard_app/pages/flashcard_form.dart';
import 'package:flashcard_app/pages/review_page.dart';
// Import the ReviewPage
import 'package:flutter/material.dart';

class ListFlashcardPage extends StatefulWidget {
  final Topic selectedTopic; // Accept selected Topic

  const ListFlashcardPage({
    super.key,
    required this.selectedTopic,
  }); // Modified constructor

  @override
  State<ListFlashcardPage> createState() => _ListFlashcardPageState();
}

class _ListFlashcardPageState extends State<ListFlashcardPage> {
  List<FlashCard> _cards = [];

  @override
  void initState() {
    super.initState();
    _loadCards(); // Load flashcards specific to the selected topic
  }

  // Modified to load cards for the specific topic
  void _loadCards() async {
    final data = await DbHelper.getFlashCardsByTopic(widget.selectedTopic.id!);
    setState(() {
      _cards = data;
    });
  }

  void _deleteCard(int id) async {
    // Show a confirmation dialog before deleting
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Flashcard?'),
          content: const Text('Anda yakin ingin menghapus flashcard ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                await DbHelper.deleteFlashCard(id); // Delete the flashcard
                _loadCards(); // Reload cards to update UI
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Topik: ${widget.selectedTopic.name}",
          style: TextStyle(fontSize: 18),
        ), // Display topic name
        foregroundColor: Colors.white,
        backgroundColor: AppColor.myblue,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.myblue, // Apply color
        foregroundColor: Colors.white, // Apply color
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => FlashCardFormPage(
                    topicId:
                        widget
                            .selectedTopic
                            .id, // Pass the topic ID when adding
                  ),
            ),
          );
          _loadCards(); // Reload after adding/editing
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                "Buat dan Mulai Langkah Pertamamu",
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
            // Add the "Mulai Menghafal" button here
            SizedBox(
              width: double.infinity, // Make the button full width
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_cards.isEmpty) {
                    // Show a message if there are no flashcards to review
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Tidak ada flashcard untuk dihafal di topik ini.',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) =>
                                ReviewPage(selectedTopic: widget.selectedTopic),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text(
                  'Mulai Menghafal',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.myblue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                ),
              ),
            ),
            const SizedBox(height: 16), // Spacing between button and list
            _cards.isEmpty
                ? Expanded(
                  child: Center(
                    child: Text(
                      'Belum ada flashcard untuk topik "${widget.selectedTopic.name}". Tambahkan yang baru!',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                : Expanded(
                  child: ListView.builder(
                    itemCount: _cards.length,
                    itemBuilder: (context, index) {
                      final card = _cards[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            card.question,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(card.answer),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => FlashCardFormPage(
                                            card: card,
                                            topicId:
                                                widget
                                                    .selectedTopic
                                                    .id, // Pass topic ID for editing
                                          ),
                                    ),
                                  );
                                  _loadCards(); // Reload cards after edit
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed:
                                    () => _deleteCard(card.id!), // Delete card
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
