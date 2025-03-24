import 'package:flutter/material.dart';
import 'package:mannerisms/home/model/culture_model.dart';
import 'package:mannerisms/home/repository/culture_repository.dart';

class CultureViewModel extends ChangeNotifier {
  final CultureRepository _repository;
  List<CultureModel> _cultures = [];
  String? _selectedCulture;
  bool _isAdvanced = false;

  CultureViewModel(this._repository) {
    _loadCultures();
  }

  List<CultureModel> get cultures => _cultures;
  String? get selectedCulture => _selectedCulture;
  bool get isAdvanced => _isAdvanced;

  void _loadCultures() {
    _cultures = _repository.getCultures();
    notifyListeners();
  }

  void selectCulture(String tag) {
    _selectedCulture = tag;
    notifyListeners();
  }

  void toggleDifficulty() {
    _isAdvanced = !_isAdvanced;
    notifyListeners();
  }

  bool isAvanced() {
    return _isAdvanced;
  }

  bool canProceed() {
    return _selectedCulture != null;
  }
} 