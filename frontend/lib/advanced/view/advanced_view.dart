import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mannerisms/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:mannerisms/advanced/viewmodel/advanced_viewmodel.dart';
import 'package:mannerisms/services/auth_viewmodel.dart';
import 'package:mannerisms/services/auth_interceptor.dart';
import 'package:mannerisms/login/view/login_view.dart';
import 'package:mannerisms/home/view/culture_selection_view.dart';
import 'package:mannerisms/home/viewmodel/culture_viewmodel.dart';

class AdvancedView extends StatefulWidget {
  const AdvancedView({super.key});

  @override
  State<AdvancedView> createState() => _AdvancedViewState();
}

class _AdvancedViewState extends State<AdvancedView> {
  final _authInterceptor = AuthInterceptor();
  bool _isAnswering = false;
  String explanation = '';
  int score = 0;
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cultureViewModel = context.read<CultureViewModel>();
      if (cultureViewModel.selectedCulture == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CultureSelectionView()),
        );
      } else {
        context.read<AdvancedViewModel>().loadBigQuestion();
      }
    });
  }

  Future<void> _handleAnswer(String questionId) async {
    if (_isAnswering) return;

    final authViewModel = context.read<AuthViewModel>();
    final advancedViewModel = context.read<AdvancedViewModel>();

    if (!authViewModel.isAuthenticated) {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
          (route) => false,
        );
      }
      return;
    }

    setState(() {
      _isAnswering = true;
    });

    try {
      final headers = await _authInterceptor.getAuthHeaders();
      final result = await advancedViewModel.submitAnswer(
        questionId,
        _answerController.text,
        headers,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        setState(() {
          score = result['score'];
          explanation = result['response'];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAnswering = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mannerisms'),
        leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, AppConstants.cultureRoute, (route) => false)),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              score = 0;
              explanation = '';
              _answerController.clear();
              context.read<AdvancedViewModel>().loadBigQuestion();
            },
          ),
        ],
      ),
      body: Consumer<AdvancedViewModel>(
        builder: (context, viewModel, child) {
          debugPrint("viewModel.questionId: ${viewModel.questionId}");
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    viewModel.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.loadBigQuestion(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.question.isEmpty) {
            return const Center(
              child: Text('No advanced questions available'),
            );
          }

          final question = viewModel.question;
          if (score == 0 && explanation.isEmpty) {
            return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question,
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 150,
                      child: TextField(
                        controller: _answerController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Your Answer',
                          hintText: 'Type your answer here...',
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        maxLength: 100,
                        minLines: 5,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isAnswering
                            ? null
                            : () {
                                _handleAnswer(viewModel.questionId);
                              },
                        child: _isAnswering
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.onPrimary),
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Submit'),
                      ),
                    ),
                  ],
                ));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Score: $score",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface,
                          fontSize:
                              28,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    explanation,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
