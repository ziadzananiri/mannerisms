import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mannerisms/login/model/login_model.dart';
import 'package:mannerisms/utils/constants.dart';

class LoginRepository {
  final http.Client _client;

  LoginRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> login(LoginModel loginData) async {
    try {
      final response = await _client.post(
        Uri.parse('${AppConstants.apiUrl}${AppConstants.loginEndpoint}'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'username': loginData.email,
          'password': loginData.password,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['detail'] ?? 'Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
} 