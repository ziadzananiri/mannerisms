import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mannerisms/utils/theme.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'is_dark_mode';
  final _storage = const FlutterSecureStorage();
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  ThemeData get theme => _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDarkModeString = await _storage.read(key: _themeKey);
    _isDarkMode = isDarkModeString == 'true';
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _storage.write(key: _themeKey, value: _isDarkMode.toString());
    notifyListeners();
  }
} 