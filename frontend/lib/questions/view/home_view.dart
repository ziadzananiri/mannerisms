import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mannerisms/questions/viewmodel/home_viewmodel.dart';
import 'package:mannerisms/services/auth_viewmodel.dart';
import 'package:mannerisms/questions/model/question_model.dart';
import 'package:mannerisms/services/auth_interceptor.dart';
import 'package:mannerisms/login/view/login_view.dart';
import 'package:mannerisms/home/view/culture_selection_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _authInterceptor = AuthInterceptor();
  bool _isAnswering = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadQuestions();
    });
  }

  Future<void> _handleAnswer(QuestionModel question, String answer) async {
    if (_isAnswering) return;
    
    final authViewModel = context.read<AuthViewModel>();
    final homeViewModel = context.read<HomeViewModel>();
    
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

    setState(() => _isAnswering = true);

    try {
      final headers = await _authInterceptor.getAuthHeaders();
      final result = await homeViewModel.submitAnswer(
        question.id,
        answer,
        headers,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['correct'] ? 'Correct!' : 'Not quite right...'),
            backgroundColor: result['correct'] ? Colors.green : Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
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
        setState(() => _isAnswering = false);
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
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const CultureSelectionView()),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<HomeViewModel>().loadQuestions(),
          ),
        ],
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
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
                    onPressed: () => viewModel.loadQuestions(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.questions.isEmpty) {
            return const Center(
              child: Text('No questions available'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.questions.length,
            itemBuilder: (context, index) {
              final question = viewModel.questions[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.tag,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        question.question,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      ...question.options.map((option) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isAnswering ? null : () => _handleAnswer(question, option),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(option),
                          ),
                        ),
                      )),
                      const SizedBox(height: 16),
                      if (viewModel.lastCorrectAnswerTag == question.tag)
                        Text(
                          'Explanation: ${question.explanation}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 