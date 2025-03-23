import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mannerisms/utils/constants.dart';
import 'package:flutter/foundation.dart';

class AuthInterceptor {
  static const String baseUrl = AppConstants.apiUrl;
  final _storage = const FlutterSecureStorage();
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<void> deleteTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  Future<bool> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) return false;

      final response = await http.post(
        Uri.parse('$baseUrl/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await saveTokens(data['access_token'], data['refresh_token']);
        return true;
      } else if (response.statusCode == 401) {
        await deleteTokens();
        return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, String>> getAuthHeaders() async {
    final accessToken = await getAccessToken();
    debugPrint('Retrieved access token: $accessToken');
    if (accessToken == null) {
      throw Exception('No access token found');
    }
    return {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
  }

  Future<http.Response> handleRequest(Future<http.Response> Function() request) async {
    try {
      final response = await request();
      if (response.statusCode == 401) {
        final refreshed = await refreshToken();
        if (refreshed) {
          return await request();
        } else {
          throw Exception('Token refresh failed');
        }
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }
} 