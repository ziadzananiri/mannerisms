import 'package:flutter/foundation.dart';
import 'package:mannerisms/services/auth_interceptor.dart';
import 'package:mannerisms/login/model/login_model.dart';
import 'package:mannerisms/login/repository/login_repository.dart';
import 'package:mannerisms/services/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:mannerisms/utils/constants.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginRepository _repository;
  final AuthViewModel _authViewModel;
  final AuthInterceptor _authInterceptor;
  bool _isLoading = false;
  String _error = '';

  LoginViewModel({
    required LoginRepository repository,
    required AuthViewModel authViewModel,
    required AuthInterceptor authInterceptor,
  })  : _repository = repository,
        _authViewModel = authViewModel,
        _authInterceptor = authInterceptor;

  bool get isLoading => _isLoading;
  String get error => _error;

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final loginData = LoginModel(email: email, password: password);
      final response = await _repository.login(loginData);
      print('Login response: $response'); // Debug log

      if (response != null) {
        await _authInterceptor.saveTokens(
          response['access_token'],
          response['refresh_token'],
        );
        print('Tokens saved successfully'); // Debug log
        _authViewModel.setAuthenticated(true);
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      print('Login error: $_error'); // Debug log
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
} 