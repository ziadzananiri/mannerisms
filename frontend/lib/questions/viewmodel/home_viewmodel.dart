import 'package:flutter/foundation.dart';
import 'package:mannerisms/questions/model/question_model.dart';
import 'package:mannerisms/questions/repository/question_repository.dart';
import 'package:mannerisms/home/viewmodel/culture_viewmodel.dart';
import 'package:mannerisms/services/auth_interceptor.dart';
import 'dart:convert';

class HomeViewModel extends ChangeNotifier {
  final QuestionRepository _repository;
  final CultureViewModel _cultureViewModel;
  final AuthInterceptor _authInterceptor = AuthInterceptor();
  List<QuestionModel> _questions = [];
  bool _isLoading = false;
  String? _error;
  String? _lastCorrectAnswerTag;

  HomeViewModel(this._repository, this._cultureViewModel);

  List<QuestionModel> get questions => _questions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get lastCorrectAnswerTag => _lastCorrectAnswerTag;

  Future<void> loadQuestions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final selectedCulture = _cultureViewModel.selectedCulture;
      if (selectedCulture == null) {
        throw Exception('No culture selected');
      }
      _questions = await _repository.getQuestions(selectedCulture);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> submitAnswer(String questionId, String answer, Map<String, String> headers) async {
    try {
      final result = await _repository.submitAnswer(questionId, answer, headers);
      if (result['correct']) {
        final question = _questions.firstWhere((q) => q.id == questionId);
        _lastCorrectAnswerTag = question.tag;
      } else {
        _lastCorrectAnswerTag = null;
      }
      notifyListeners();
      return result;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
} 