import 'package:flashcard_app/constant/app_color.dart';
import 'package:flashcard_app/database/db_helper.dart';
import 'package:flashcard_app/flashcard_form.dart';
import 'package:flashcard_app/model/flashcard_model.dart';
import 'package:flutter/material.dart';

class ListFlashcardPage extends StatefulWidget {
  const ListFlashcardPage({super.key});

  @override
  State<ListFlashcardPage> createState() => _ListFlashcardPageState();
}

class _ListFlashcardPageState extends State<ListFlashcardPage> {
  List<FlashCard> _cards = [];

  void _loadCards() async {
    final data = await DbHelper.getAllFlashCards();
    setState(() {
      _cards = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  void _deleteCard(int id) async {
    await DbHelper.deleteFlashCard(id);
    _loadCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("List of Flashcard"),
        foregroundColor: Colors.white,
        backgroundColor: AppColor.myblue,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FlashCardFormPage()),
          );
          _loadCards();
          // reload setelah tambah
        },
      ),
      body: ListView.builder(
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];
          return ListTile(
            title: Text(card.question),
            subtitle: Text(card.answer),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FlashCardFormPage(card: card),
                      ),
                    );
                    _loadCards();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteCard(card.id!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
