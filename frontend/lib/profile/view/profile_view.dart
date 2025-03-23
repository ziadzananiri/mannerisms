import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mannerisms/profile/viewmodel/profile_viewmodel.dart';
import 'package:mannerisms/services/auth_interceptor.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  final _authInterceptor = AuthInterceptor();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final headers = await _authInterceptor.getAuthHeaders();
      if (!mounted) return;
      context.read<ProfileViewModel>().loadUserProgress(headers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              final headers = await _authInterceptor.getAuthHeaders();
              if (!context.mounted) return;
              context.read<ProfileViewModel>().loadUserProgress(headers);
            },
          ),
        ],
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(viewModel.error),
                  ElevatedButton(
                    onPressed: () async {
                      final headers = await _authInterceptor.getAuthHeaders();
                      if (!mounted) return;
                      viewModel.loadUserProgress(headers);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final progress = viewModel.progress;
          if (progress == null) {
            return const Center(
              child: Text('No progress data available'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person, size: 50),
                ),
                const SizedBox(height: 24),
                Text(
                  progress.user.username,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildStatItem(
                          context,
                          'Completed Questions',
                          progress.completedQuestions.toString(),
                          Icons.check_circle,
                        ),
                        const Divider(),
                        _buildStatItem(
                          context,
                          'Score',
                          progress.score.toString(),
                          Icons.star,
                        ),
                        const Divider(),
                        _buildStatItem(
                          context,
                          'Last Activity',
                          _formatDate(progress.lastActivity),
                          Icons.access_time,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
} 