class AdvancedQuestionModel {
  final String question;
  final String id;
  final String culture;

  AdvancedQuestionModel({
    required this.id,
    required this.question,
    required this.culture,
  });

  factory AdvancedQuestionModel.fromJson(Map<String, dynamic> json) {
    return AdvancedQuestionModel(
      id: json['id'],
      question: json['question'],
      culture: json['culture'],
    );
  }
} 