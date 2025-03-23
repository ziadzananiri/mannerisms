class ProgressModel {
  final String id;
  final UserModel user;
  final int score;
  final List<String> completedQuestions;
  final DateTime lastActivity;

  ProgressModel({
    required this.id,
    required this.user,
    required this.score,
    required this.completedQuestions,
    required this.lastActivity,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      id: json['_id'],
      user: UserModel.fromJson(json['user']),
      score: json['score'] ?? 0,
      completedQuestions: List<String>.from(json['completed_questions'] ?? []),
      lastActivity: DateTime.parse(json['last_activity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user.toJson(),
      'score': score,
      'completed_questions': completedQuestions,
      'last_activity': lastActivity.toIso8601String(),
    };
  }
}

class UserModel {
  final String id;
  final String username;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      username: json['username'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'created_at': createdAt.toIso8601String(),
    };
  }
} 