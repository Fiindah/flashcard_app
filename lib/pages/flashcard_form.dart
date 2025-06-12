import 'package:flashcard_app/constant/app_color.dart'; // Make sure this import is correct if you use it
import 'package:flashcard_app/database/db_helper.dart';
import 'package:flashcard_app/model/flashcard_model.dart';
import 'package:flutter/material.dart';

class FlashCardFormPage extends StatefulWidget {
  final FlashCard? card;
  final int? topicId;

  const FlashCardFormPage({super.key, this.card, this.topicId});

  @override
  State<FlashCardFormPage> createState() => _FlashCardFormPageState();
}

class _FlashCardFormPageState extends State<FlashCardFormPage> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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
      final question = _questionController.text;
      final answer = _answerController.text;

      if (widget.card == null) {
        final newCard = FlashCard(
          question: question,
          answer: answer,
          topicId: widget.topicId,
        );
        await DbHelper.insertFlashCard(newCard);
      } else {
        final updatedCard = FlashCard(
          id: widget.card!.id,
          question: question,
          answer: answer,
          repeatCard: widget.card!.repeatCard,
          remembered: widget.card!.remembered,
          topicId: widget.card!.topicId,
        );
        await DbHelper.updateFlashCard(updatedCard);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.card == null ? 'Tambah Flashcard Baru' : 'Edit Flashcard',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColor.myblue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(
                  labelText: 'Pertanyaan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  prefixIcon: Icon(Icons.question_mark),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pertanyaan tidak boleh kosong';
                  }
                  return null;
                },
                maxLines: null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _answerController,
                decoration: const InputDecoration(
                  labelText: 'Jawaban',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  prefixIcon: Icon(Icons.lightbulb_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jawaban tidak boleh kosong';
                  }
                  return null;
                },
                maxLines: null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveFlashCard,
                  label: Text(widget.card == null ? 'Simpan' : 'Perbarui'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: AppColor.myblue,
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
