import 'package:flutter/foundation.dart';
import 'package:mannerisms/advanced/repository/advanced_repository.dart';
import 'package:mannerisms/home/viewmodel/culture_viewmodel.dart';

class AdvancedViewModel extends ChangeNotifier {
  final AdvancedRepository _repository;
  final CultureViewModel _cultureViewModel;
  String _question = '';
  String _questionId = '';
  String _culture = '';
  bool _isLoading = false;
  String? _error;
  String? _lastCorrectAnswerTag;

  AdvancedViewModel(this._repository, this._cultureViewModel);

  String get question => _question;
  String get questionId => _questionId;
  String get culture => _culture;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get lastCorrectAnswerTag => _lastCorrectAnswerTag;

  Future<void> loadBigQuestion() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final selectedCulture = _cultureViewModel.selectedCulture;
      if (selectedCulture == null) {
        throw Exception('No culture selected');
      }
      final response = await _repository.getBigQuestion(selectedCulture);
      _question = response.question;
      _questionId = response.id.toString();
      _culture = response.culture;
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
      debugPrint("result: $result");
      notifyListeners();
      return result;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
} 