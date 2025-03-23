import 'package:flutter/foundation.dart';
import 'package:mannerisms/signup/model/signup_model.dart';
import 'package:mannerisms/signup/repository/signup_repository.dart';

class SignupViewModel extends ChangeNotifier {
  final SignupRepository _repository;
  bool _isLoading = false;
  String _error = '';

  SignupViewModel({
    required SignupRepository repository,
  }) : _repository = repository;

  bool get isLoading => _isLoading;
  String get error => _error;

  Future<bool> signup(String username, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final signupData = SignupModel(username: username, password: password);
      await _repository.signup(signupData);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
} 