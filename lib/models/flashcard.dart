class Flashcard {
  String id;
  String question;
  String answer;
  bool isAnswerVisible;

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    this.isAnswerVisible = false,
  });
}
