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


  void init() {
    // Initialize services
    authInterceptor = AuthInterceptor();
    
    // Initialize repositories
    questionRepository = QuestionRepository();
    progressRepository = ProgressRepository();
    
    // Initialize view models
    authViewModel = AuthViewModel();
    cultureRepository = CultureRepository();
    cultureViewModel = CultureViewModel(cultureRepository);
    homeViewModel = HomeViewModel(questionRepository, cultureViewModel);
    profileViewModel = ProfileViewModel(progressRepository);
    loginRepository = LoginRepository();
    loginViewModel = LoginViewModel(
      repository: loginRepository,
      authInterceptor: authInterceptor,
      authViewModel: authViewModel,
    );
    signupRepository = SignupRepository();
    signupViewModel = SignupViewModel(
      repository: signupRepository,
    );
  }

  List<ChangeNotifierProvider> get providers => [
    ChangeNotifierProvider<AuthViewModel>.value(value: authViewModel),
    ChangeNotifierProvider<HomeViewModel>.value(value: homeViewModel),
    ChangeNotifierProvider<ProfileViewModel>.value(value: profileViewModel),
    ChangeNotifierProvider<LoginViewModel>.value(value: loginViewModel),
    ChangeNotifierProvider<SignupViewModel>.value(value: signupViewModel),
    ChangeNotifierProvider<CultureViewModel>.value(value: cultureViewModel),
  ];
} 