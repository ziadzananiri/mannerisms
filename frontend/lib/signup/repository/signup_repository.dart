import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mannerisms/signup/model/signup_model.dart';
import 'package:mannerisms/utils/constants.dart';

class SignupRepository {
  final http.Client _client;

  SignupRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> signup(SignupModel signupData) async {
    try {
      final response = await _client.post(
        Uri.parse('${AppConstants.apiUrl}/users/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(signupData.toJson()),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['detail'] ?? 'Failed to signup: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
} 