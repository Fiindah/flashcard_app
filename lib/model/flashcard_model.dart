import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class FlashCard {
  final int? id;
  final String question;
  final String answer;
  FlashCard({this.id, required this.question, required this.answer});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'question': question, 'answer': answer};
  }

  factory FlashCard.fromMap(Map<String, dynamic> map) {
    return FlashCard(
      id: map['id'] != null ? map['id'] as int : null,
      question: map['question'] as String,
      answer: map['answer'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FlashCard.fromJson(String source) =>
      FlashCard.fromMap(json.decode(source) as Map<String, dynamic>);
}
