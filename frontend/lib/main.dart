import 'package:flutter/material.dart';
import 'package:mannerisms/home/view/culture_selection_view.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mannerisms/utils/service_locator.dart';
import 'package:mannerisms/utils/navigation_service.dart';
import 'package:mannerisms/login/view/login_view.dart';
import 'package:mannerisms/services/auth_viewmodel.dart';
import 'package:mannerisms/utils/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GoogleFonts.pendingFonts();
  
  final serviceLocator = ServiceLocator();
  serviceLocator.init();
  
  runApp(MyApp(serviceLocator: serviceLocator));
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        if (authViewModel.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return authViewModel.isAuthenticated 
          ? const CultureSelectionView()
          : const LoginView();
      },
    );
  }
}

class MyApp extends StatelessWidget {
  final ServiceLocator serviceLocator;
  
  const MyApp({
    super.key,
    required this.serviceLocator,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: serviceLocator.providers,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Mannerisms',
            theme: themeProvider.theme,
            navigatorKey: NavigationService().navigatorKey,
            onGenerateRoute: NavigationService().generateRoute,
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}
