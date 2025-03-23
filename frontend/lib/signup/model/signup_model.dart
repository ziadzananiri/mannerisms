class SignupModel {
  final String username;
  final String password;

  SignupModel({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
  };
}

class SignupResponseModel {
  final String id;
  final String username;
  final String createdAt;

  SignupResponseModel({
    required this.id,
    required this.username,
    required this.createdAt,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      id: json['_id'],
      username: json['username'],
      createdAt: json['created_at'],
    );
  }
} 