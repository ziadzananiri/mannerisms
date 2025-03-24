import 'package:provider/provider.dart';
import 'package:mannerisms/questions/repository/question_repository.dart';
import 'package:mannerisms/profile/repository/progress_repository.dart';
import 'package:mannerisms/services/auth_viewmodel.dart';
import 'package:mannerisms/questions/viewmodel/home_viewmodel.dart';
import 'package:mannerisms/profile/viewmodel/profile_viewmodel.dart';
import 'package:mannerisms/services/auth_interceptor.dart';
import 'package:mannerisms/login/repository/login_repository.dart';
import 'package:mannerisms/login/viewmodel/login_viewmodel.dart';
import 'package:mannerisms/signup/viewmodel/signup_viewmodel.dart';
import 'package:mannerisms/signup/repository/signup_repository.dart';
import 'package:mannerisms/home/repository/culture_repository.dart';
import 'package:mannerisms/home/viewmodel/culture_viewmodel.dart';
import 'package:mannerisms/menu/viewmodel/menu_viewmodel.dart';
import 'package:mannerisms/utils/theme_provider.dart';
import 'package:mannerisms/advanced/viewmodel/advanced_viewmodel.dart';
import 'package:mannerisms/advanced/repository/advanced_repository.dart';
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  late final AuthInterceptor authInterceptor;
  late final QuestionRepository questionRepository;
  late final ProgressRepository progressRepository;
  late final AuthViewModel authViewModel;
  late final HomeViewModel homeViewModel;
  late final ProfileViewModel profileViewModel;
  late final LoginRepository loginRepository;
  late final LoginViewModel loginViewModel;
  late final SignupRepository signupRepository;
  late final SignupViewModel signupViewModel;
  late final CultureRepository cultureRepository;
  late final CultureViewModel cultureViewModel;
  late final MenuViewModel menuViewModel;
  late final ThemeProvider themeProvider;
  late final AdvancedViewModel advancedViewModel;
  late final AdvancedRepository advancedRepository;
  void init() {
    // Initialize services
    authInterceptor = AuthInterceptor();
    
    // Initialize repositories
    questionRepository = QuestionRepository();
    progressRepository = ProgressRepository();
    cultureRepository = CultureRepository();
    loginRepository = LoginRepository();
    signupRepository = SignupRepository();
    advancedRepository = AdvancedRepository();
    
    // Initialize view models
    authViewModel = AuthViewModel();
    cultureViewModel = CultureViewModel(cultureRepository);
    homeViewModel = HomeViewModel(questionRepository, cultureViewModel);
    profileViewModel = ProfileViewModel(progressRepository);
    loginViewModel = LoginViewModel(
      repository: loginRepository,
      authInterceptor: authInterceptor,
      authViewModel: authViewModel,
    );
    signupViewModel = SignupViewModel(
      repository: signupRepository,
    );
    menuViewModel = MenuViewModel();
    themeProvider = ThemeProvider();
    advancedViewModel = AdvancedViewModel(advancedRepository, cultureViewModel);
  }

  List<ChangeNotifierProvider> get providers => [
    ChangeNotifierProvider<AuthViewModel>.value(value: authViewModel),
    ChangeNotifierProvider<HomeViewModel>.value(value: homeViewModel),
    ChangeNotifierProvider<ProfileViewModel>.value(value: profileViewModel),
    ChangeNotifierProvider<LoginViewModel>.value(value: loginViewModel),
    ChangeNotifierProvider<SignupViewModel>.value(value: signupViewModel),
    ChangeNotifierProvider<CultureViewModel>.value(value: cultureViewModel),
    ChangeNotifierProvider<MenuViewModel>.value(value: menuViewModel),
    ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
    ChangeNotifierProvider<AdvancedViewModel>.value(value: advancedViewModel),
  ];
} 