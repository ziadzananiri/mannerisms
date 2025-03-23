import 'package:flutter/foundation.dart';
import 'auth_interceptor.dart';
import 'http_service.dart';
import 'package:mannerisms/utils/constants.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthInterceptor _authInterceptor = AuthInterceptor();
  final HttpService _httpService = HttpService();
  bool _isAuthenticated = false;
  bool _isLoading = true;
  String _error = '';

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String get error => _error;

  AuthViewModel() {
    checkAuthStatus();
  }

  Future<bool> checkAuthStatus() async {
    try {
      final accessToken = await _authInterceptor.getAccessToken();
      debugPrint('Checking auth status, token: $accessToken');
      _isAuthenticated = accessToken != null;
      debugPrint('Is authenticated: $_isAuthenticated');
      _error = '';
      notifyListeners();
      return _isAuthenticated;
    } catch (e) {
      _isAuthenticated = false;
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final data = await _httpService.postForm(
        AppConstants.loginEndpoint,
        {
          'username': username,
          'password': password,
        },
      );

      await _authInterceptor.saveTokens(
        data['access_token'],
        data['refresh_token'],
      );
      _isAuthenticated = true;
      _error = '';
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signup(String username, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _httpService.post(
        AppConstants.signupEndpoint,
        {
          'username': username,
          'password': password,
        },
        headers: {'Content-Type': 'application/json'},
        requiresAuth: false,
      );

      return await login(username, password);
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authInterceptor.deleteTokens();
    _isAuthenticated = false;
    notifyListeners();
  }

  void setAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }
} 