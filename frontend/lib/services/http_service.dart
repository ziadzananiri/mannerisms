import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mannerisms/utils/constants.dart';
import 'auth_interceptor.dart';

class HttpService {
  static final HttpService _instance = HttpService._internal();
  factory HttpService() => _instance;
  HttpService._internal();

  final AuthInterceptor _authInterceptor = AuthInterceptor();
  final http.Client _client = http.Client();

  Future<Map<String, String>> _getHeaders({bool requiresAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
    };

    if (requiresAuth) {
      final authHeaders = await _authInterceptor.getAuthHeaders();
      headers.addAll(authHeaders);
    }

    return headers;
  }

  Future<dynamic> get(String endpoint, {bool requiresAuth = true}) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final response = await _client.get(
        Uri.parse('${AppConstants.apiUrl}$endpoint'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers, bool requiresAuth = true}) async {
    try {
      final defaultHeaders = await _getHeaders(requiresAuth: requiresAuth);
      final finalHeaders = headers ?? defaultHeaders;
      
      final response = await _client.post(
        Uri.parse('${AppConstants.apiUrl}$endpoint'),
        headers: finalHeaders,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

  Future<dynamic> postForm(String endpoint, Map<String, String> body) async {
    try {
      final response = await _client.post(
        Uri.parse('${AppConstants.apiUrl}$endpoint'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }
} 