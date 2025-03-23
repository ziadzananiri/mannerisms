import 'package:mannerisms/profile/model/progress_model.dart';
import 'package:mannerisms/services/http_service.dart';
import 'package:mannerisms/utils/constants.dart';

class ProgressRepository {
  final HttpService _httpService = HttpService();

  Future<ProgressModel> getUserProgress(Map<String, String> headers) async {
    final data = await _httpService.get(AppConstants.progressEndpoint);
    return ProgressModel.fromJson(data);
  }

  Future<void> updateProgress(Map<String, String> headers, String questionId, bool isCorrect) async {
    await _httpService.post(
      AppConstants.progressUpdateEndpoint,
      {
        'question_id': questionId,
        'is_correct': isCorrect,
      },
      headers: headers,
    );
  }

  Future<Map<String, dynamic>> submitProgress(String questionId, String answer) async {
    return await _httpService.post(
      '${AppConstants.progressEndpoint}/$questionId/answer',
      {'answer': answer},
      headers: {'Content-Type': 'application/json'},
    );
  }
} 