import 'package:flutter/material.dart';
import 'package:mannerisms/advanced/view/advanced_view.dart';
import 'package:mannerisms/login/view/login_view.dart';
import 'package:mannerisms/main_screen.dart';
import 'package:mannerisms/questions/view/home_view.dart';
import 'package:mannerisms/profile/view/profile_view.dart';
import 'package:mannerisms/menu/view/menu_view.dart';
import 'package:mannerisms/utils/constants.dart';
import 'package:mannerisms/home/view/culture_selection_view.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstants.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case AppConstants.cultureRoute:
        return MaterialPageRoute(builder: (_) => const CultureSelectionView());
      case AppConstants.profileRoute:
        return MaterialPageRoute(builder: (_) => const ProfileView());
      case AppConstants.settingsRoute:
        return MaterialPageRoute(builder: (_) => const MenuView());
      case AppConstants.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case AppConstants.advancedRoute:
        return MaterialPageRoute(builder: (_) => const AdvancedView());
      case AppConstants.mainRoute:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      default:
        return MaterialPageRoute(builder: (_) => const CultureSelectionView());
    }
  }
} 