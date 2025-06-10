import 'package:flashcard_app/database/db_helper.dart';
import 'package:flashcard_app/model/flashcard_model.dart';
import 'package:flutter/material.dart';

class FlashCardFormPage extends StatefulWidget {
  final FlashCard? card;

  const FlashCardFormPage({super.key, this.card});

  @override
  _FlashCardFormPageState createState() => _FlashCardFormPageState();
}

class _FlashCardFormPageState extends State<FlashCardFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  void _saveCard() async {
    if (_formKey.currentState!.validate()) {
      final isEdit = widget.card != null;

      final card = FlashCard(
        id: isEdit ? widget.card!.id : null,
        question: _questionController.text,
        answer: _answerController.text,
      );
      if (isEdit) {
        await DbHelper.updateFlashCard(card);
      } else {
        await DbHelper.insertFlashCard(card);
      }
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.card != null) {
      _questionController.text = widget.card!.question;
      _answerController.text = widget.card!.answer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.card?.id != null ? "Edit Flashcard" : 'Tambah Flashcard',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _questionController,
                decoration: InputDecoration(labelText: 'Pertanyaan'),
                validator: (val) => val!.isEmpty ? 'Tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _answerController,
                decoration: InputDecoration(labelText: 'Jawaban'),
                validator: (val) => val!.isEmpty ? 'Tidak boleh kosong' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCard,
                child: Text(widget.card?.id != null ? "Perbarui" : 'Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
