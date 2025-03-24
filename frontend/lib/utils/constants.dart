class AppConstants {
  static const String apiUrl = 'http://10.0.2.2:8000';
  
  // API Endpoints
  static const String loginEndpoint = '/token';
  static const String signupEndpoint = '/users';
  static const String questionsEndpoint = '/questions';
  static const String progressEndpoint = '/progress';
  static const String progressUpdateEndpoint = '/progress/update';
  static const String advancedQuestionEndpoint = '/advancedQuestion';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';

  // Routes
  static const String homeRoute = '/home';
  static const String profileRoute = '/profile';
  static const String settingsRoute = '/settings';
  static const String loginRoute = '/login';
  static const String cultureRoute = '/culture';
  static const String advancedRoute = '/advanced';
  static const String mainRoute = '/main';
} 