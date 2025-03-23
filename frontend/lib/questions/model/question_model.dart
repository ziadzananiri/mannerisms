class QuestionModel {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final String category;
  final String tag;
  final String difficulty;
  final String culture;

  QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.category,
    required this.difficulty,
    required this.tag,
    required this.culture,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['_id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correct_answer'],
      explanation: json['explanation'],
      category: json['category'],
      tag: json['tag'],
      difficulty: json['difficulty'],
      culture: json['culture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'question': question,
      'options': options,
      'correct_answer': correctAnswer,
      'explanation': explanation,
      'category': category,
      'tag': tag,
      'difficulty': difficulty,
      'culture': culture,
    };
  }
} 