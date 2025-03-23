import 'package:flutter/foundation.dart';
import 'package:mannerisms/profile/model/progress_model.dart';
import 'package:mannerisms/profile/repository/progress_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProgressRepository _repository;
  ProgressModel? _progress;
  bool _isLoading = false;
  String _error = '';

  ProfileViewModel(this._repository);

  ProgressModel? get progress => _progress;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadUserProgress(Map<String, String> headers) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _progress = await _repository.getUserProgress(headers);
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProgress(Map<String, String> headers, String questionId, bool isCorrect) async {
    try {
      await _repository.updateProgress(headers, questionId, isCorrect);
      await loadUserProgress(headers); // Reload progress after update
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
} 