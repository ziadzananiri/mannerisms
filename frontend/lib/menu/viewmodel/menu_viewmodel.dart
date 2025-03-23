import 'package:flutter/foundation.dart';
import 'package:mannerisms/menu/model/menu_model.dart';

class MenuViewModel extends ChangeNotifier {
  bool _isLoading = false;
  MenuModel? _menu;

  MenuViewModel();

  MenuModel? get menu => _menu;
  bool get isLoading => _isLoading;

  Future<void> loadMenuItems(Map<String, String> headers) async {
    _isLoading = true;
    notifyListeners();

    _menu = MenuModel();

    _isLoading = false;
    notifyListeners();
  }
} 