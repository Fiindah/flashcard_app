import 'package:flashcard_app/constant/app_color.dart';
import 'package:flashcard_app/database/db_helper.dart';
import 'package:flashcard_app/model/flashcard_model.dart';
import 'package:flashcard_app/model/topic_model.dart';
import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  final Topic selectedTopic; // menerima topik yang dipilih

  const ReviewPage({
    super.key,
    required this.selectedTopic,
  }); // Modifikasi constructor

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<FlashCard> _card = [];
  List<FlashCard> _repeatCard = [];
  final Set<int> _remembered = {};
  int _currentIndex = 0;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  void _loadCards() async {
    final data = await DbHelper.getFlashCardsByTopic(widget.selectedTopic.id!);
    setState(() {
      _card = data;
      _repeatCard = List.from(data);
    });
  }

  // menghandle logic kartu saya hafal dan belum hafal
  // jika hafal maka lanjut ke kartu berikutnya
  void _markRemembered(bool remembered) {
    setState(() {
      // ketika mengulang kartu
      if (_repeatCard.isEmpty && remembered) {
        _showFinishDialog(
          _card.length, // total cards
          _remembered.length, // kartu yang dihafal
          _card.isNotEmpty
              ? (_remembered.length / _card.length * 100).toStringAsFixed(2)
              : "0.00",
        );
        return;
      } else if (_repeatCard.isEmpty && !remembered) {
        // If not remembered, and no cards left
        return;
      }

      final currentCard = _repeatCard[_currentIndex]; // Get the current card.

      if (remembered) {
        _remembered.add(currentCard.id!);
        _repeatCard.removeAt(_currentIndex);

        // menyembunyikan jawaban kartu.
        _showAnswer = false;

        if (_repeatCard.isEmpty) {
          // Calculate statistics before showing the dialog
          final totalCards = _card.length;
          final rememberedCards = _remembered.length;
          final accuracy =
              totalCards > 0
                  ? (rememberedCards / totalCards * 100).toStringAsFixed(2)
                  : "0.00";

          _showFinishDialog(
            totalCards,
            rememberedCards,
            accuracy,
          ); // menampilkan dialog
        } else {
          if (_currentIndex >= _repeatCard.length) {
            _currentIndex = 0;
          }
        }
      } else {
        _showAnswer = false;
      }
    });
  }

  // menampilkan hasil dari halaman review dengan statistics.
  void _showFinishDialog(int totalCards, int rememberedCards, String accuracy) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('🎉 Selesai!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Semua flashcard telah kamu hafal!'),
                const SizedBox(height: 10),
                const Text(
                  'Statistik:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Total Flashcard: $totalCards'),
                Text('Flashcard Dihafal: $rememberedCards'),
                Text('Akurasi: $accuracy%'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Oke'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_card.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Flashcard: ${widget.selectedTopic.name}")),
        body: const Center(
          child: Text('Tidak ada flashcard yang tersedia untuk topik ini.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          " ${widget.selectedTopic.name}",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColor.myblue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => setState(() => _showAnswer = !_showAnswer),
            child: Center(
              child: SizedBox(
                height: 300,
                width: double.infinity,
                child: Card(
                  margin: const EdgeInsets.all(18),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    child: Text(
                      _repeatCard.isEmpty
                          ? "Review Complete!"
                          : _showAnswer
                          ? _repeatCard[_currentIndex].answer
                          : _repeatCard[_currentIndex].question,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Buttons ("Saya Hafal", "Belum Hafal") only appear when the answer is shown.
          if (_showAnswer &&
              _repeatCard
                  .isNotEmpty) // Only show buttons if answer is visible and there are cards
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  // Use Expanded to give buttons equal width
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ), // Add padding for spacing
                    child: ElevatedButton(
                      onPressed: () => _markRemembered(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        'Saya Hafal',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ElevatedButton(
                      onPressed: () => _markRemembered(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        'Belum Hafal',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
