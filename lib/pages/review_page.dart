import 'package:flashcard_app/database/db_helper.dart';
import 'package:flashcard_app/model/flashcard_model.dart';
import 'package:flashcard_app/model/topic_model.dart'; // Import Topic model
import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  final Topic selectedTopic; // New: Accept selected Topic

  const ReviewPage({
    super.key,
    required this.selectedTopic,
  }); // Modified constructor

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  // Stores all flashcards loaded for the selected topic.
  List<FlashCard> _card = [];
  // Stores flashcards that need to be repeated. This list is modified during review.
  List<FlashCard> _repeatCard = [];
  // A set to keep track of the IDs of flashcards the user has remembered.
  final Set<int> _remembered = {};
  // The index of the current flashcard being displayed from _repeatCard.
  int _currentIndex = 0;
  // A boolean to toggle between showing the question (false) and the answer (true).
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _loadCards(); // Load flashcards for the selected topic when the widget initializes.
  }

  // Asynchronously loads flashcards for the selected topic from the database.
  void _loadCards() async {
    final data = await DbHelper.getFlashCardsByTopic(widget.selectedTopic.id!);
    setState(() {
      _card = data; // Store all original cards for this topic.
      _repeatCard = List.from(
        data,
      ); // Initialize _repeatCard with all cards for this topic.
    });
  }

  // Handles the logic for marking a card as remembered or not remembered.
  // This method also handles moving to the next card or showing the finish dialog.
  void _markRemembered(bool remembered) {
    setState(() {
      // Handle scenario where _repeatCard might become empty before a new card is shown
      if (_repeatCard.isEmpty && remembered) {
        _showFinishDialog(
          _card.length, // total cards
          _remembered.length, // remembered cards
          _card.isNotEmpty
              ? (_remembered.length / _card.length * 100).toStringAsFixed(2)
              : "0.00",
        );
        return;
      } else if (_repeatCard.isEmpty && !remembered) {
        // If not remembered, and no cards left, just return (no action needed)
        return;
      }

      final currentCard = _repeatCard[_currentIndex]; // Get the current card.

      if (remembered) {
        // If remembered, add its ID to the remembered set and remove it from _repeatCard.
        _remembered.add(currentCard.id!);
        _repeatCard.removeAt(_currentIndex);

        // Always hide the answer when moving to the next card.
        _showAnswer = false;

        // After removing, check if there are any cards left to review.
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
          ); // Show the finish dialog with stats.
        } else {
          // Adjust _currentIndex for the next card.
          // If the current index is now out of bounds (e.g., if we removed the last card),
          // reset _currentIndex to 0 to loop back to the start of the remaining cards.
          if (_currentIndex >= _repeatCard.length) {
            _currentIndex = 0;
          }
          // No need to increment _currentIndex here as removeAt already shifts elements.
          // The card at _currentIndex is now the next card to review.
        }
      } else {
        // If not remembered ("Belum Hafal"), do NOT remove or move the card.
        // We just want to flip it back to the question side to repeat it.
        _showAnswer = false; // Set to false to show the question again.
        // _currentIndex remains the same, so the same card will be shown.
      }
    });
  }

  // Displays an alert dialog when all flashcards have been reviewed, now with statistics.
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
    // Show a loading/empty message if no flashcards are loaded yet.
    if (_card.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Flashcard: ${widget.selectedTopic.name}"),
        ), // Updated AppBar
        body: const Center(
          child: Text('Tidak ada flashcard yang tersedia untuk topik ini.'),
        ), // Specific message
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Flashcard: ${widget.selectedTopic.name}"),
      ), // Display topic name
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Flashcard display area, responds to taps to show/hide answer.
          GestureDetector(
            onTap: () => setState(() => _showAnswer = !_showAnswer),
            child: Center(
              child: SizedBox(
                height: 300,
                width: double.infinity,
                child: Card(
                  margin: const EdgeInsets.all(24),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ), // Added rounded corners
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    alignment:
                        Alignment
                            .center, // Center text vertically and horizontally
                    child: Text(
                      _repeatCard
                              .isEmpty // Handle case where _repeatCard might become empty before a new card is shown
                          ? "Review Complete!" // Or a placeholder text
                          : _showAnswer
                          ? _repeatCard[_currentIndex].answer
                          : _repeatCard[_currentIndex].question,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ), // Enhanced text style
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
                        backgroundColor:
                            Colors.green.shade600, // Slightly darker green
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ), // Larger touch area
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ), // Rounded buttons
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
                  // Use Expanded
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ), // Add padding for spacing
                    child: ElevatedButton(
                      onPressed: () => _markRemembered(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.red.shade600, // Slightly darker red
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
