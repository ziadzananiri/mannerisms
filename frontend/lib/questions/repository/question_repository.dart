import 'package:mannerisms/questions/model/question_model.dart';
import 'package:mannerisms/services/http_service.dart';
import 'package:mannerisms/utils/constants.dart';

class QuestionRepository {
  final HttpService _httpService = HttpService();

  Future<List<QuestionModel>> getQuestions(String culture) async {
    final data = await _httpService.get(
      '${AppConstants.questionsEndpoint}?culture=$culture',
      requiresAuth: false,
    );
    final List<dynamic> questions = data;
    return questions.map((json) {
      return QuestionModel.fromJson(json);
    }).toList();
  }

  Future<Map<String, dynamic>> submitAnswer(String questionId, String answer, Map<String, String> headers) async {
    return await _httpService.post(
      '${AppConstants.questionsEndpoint}/$questionId/answer',
      {'user_answer': answer},
      headers: headers,
    );
  }
} 