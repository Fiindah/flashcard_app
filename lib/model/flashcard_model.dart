class FlashCard {
  final int? id;
  final String question;
  final String answer;
  final int repeatCard;
  final int remembered;
  final int? topicId; // New: Foreign key to the topic table

  FlashCard({
    this.id,
    required this.question,
    required this.answer,
    this.repeatCard = 0,
    this.remembered = 0,
    this.topicId, // Initialize new field
  });

  // Convert a FlashCard object into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'repeatCard': repeatCard,
      'remembered': remembered,
      'topic_id': topicId, // Include new field
    };
  }

  // Implement fromMap to create a FlashCard object from a Map.
  factory FlashCard.fromMap(Map<String, dynamic> map) {
    return FlashCard(
      id: map['id'] as int?,
      question: map['question'] as String,
      answer: map['answer'] as String,
      repeatCard: map['repeatCard'] as int,
      remembered: map['remembered'] as int,
      topicId: map['topic_id'] as int?, // Include new field
    );
  }

  // Optional: For debugging or logging purposes
  @override
  String toString() {
    return 'FlashCard(id: $id, question: $question, answer: $answer, repeatCard: $repeatCard, remembered: $remembered, topicId: $topicId)';
  }
}
