import 'package:flashcard_app/constant/app_color.dart'; // Make sure this import is correct if you use it
import 'package:flashcard_app/database/db_helper.dart';
import 'package:flashcard_app/model/flashcard_model.dart';
import 'package:flutter/material.dart';

class FlashCardFormPage extends StatefulWidget {
  final FlashCard? card; // Optional: for editing an existing card
  final int? topicId; // New: to associate new cards with a topic

  const FlashCardFormPage({
    super.key,
    this.card,
    this.topicId,
  }); // Modified constructor

  @override
  State<FlashCardFormPage> createState() => _FlashCardFormPageState();
}

class _FlashCardFormPageState extends State<FlashCardFormPage> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Key for form validation

  @override
  void initState() {
    super.initState();
    // If a card is passed, populate the fields for editing
    if (widget.card != null) {
      _questionController.text = widget.card!.question;
      _answerController.text = widget.card!.answer;
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _saveFlashCard() async {
    if (_formKey.currentState!.validate()) {
      // Validate the form
      final question = _questionController.text;
      final answer = _answerController.text;

      if (widget.card == null) {
        // Create new flashcard
        final newCard = FlashCard(
          question: question,
          answer: answer,
          topicId: widget.topicId, // Assign the topic ID from the widget
        );
        await DbHelper.insertFlashCard(newCard);
      } else {
        // Update existing flashcard
        final updatedCard = FlashCard(
          id: widget.card!.id,
          question: question,
          answer: answer,
          repeatCard: widget.card!.repeatCard,
          remembered: widget.card!.remembered,
          topicId: widget.card!.topicId, // Maintain the original topic ID
        );
        await DbHelper.updateFlashCard(updatedCard);
      }
      Navigator.pop(context); // Go back to the previous page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.card == null ? 'Tambah Flashcard Baru' : 'Edit Flashcard',
        ),
        centerTitle: true,
        backgroundColor: AppColor.myblue, // Added app bar color
        foregroundColor: Colors.white, // Added foreground color for text/icons
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Assign the form key
          child: Column(
            children: [
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(
                  labelText: 'Pertanyaan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ), // Rounded borders
                  ),
                  prefixIcon: Icon(Icons.question_mark),
                ),
                validator: (value) {
                  // Add validation
                  if (value == null || value.isEmpty) {
                    return 'Pertanyaan tidak boleh kosong';
                  }
                  return null;
                },
                maxLines: null, // Allows multiple lines of input
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _answerController,
                decoration: const InputDecoration(
                  labelText: 'Jawaban',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ), // Rounded borders
                  ),
                  prefixIcon: Icon(Icons.lightbulb_outline),
                ),
                validator: (value) {
                  // Add validation
                  if (value == null || value.isEmpty) {
                    return 'Jawaban tidak boleh kosong';
                  }
                  return null;
                },
                maxLines: null, // Allows multiple lines of input
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, // Make button fill width
                child: ElevatedButton.icon(
                  onPressed: _saveFlashCard,
                  icon: const Icon(Icons.save),
                  label: Text(
                    widget.card == null
                        ? 'Simpan Flashcard'
                        : 'Perbarui Flashcard',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ), // Rounded button
                    backgroundColor:
                        AppColor.myblue, // Use AppColor.myblue for consistency
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
