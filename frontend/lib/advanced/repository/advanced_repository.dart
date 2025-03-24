import 'package:mannerisms/advanced/model/advanced_model.dart';
import 'package:mannerisms/services/http_service.dart';
import 'package:mannerisms/utils/constants.dart';

class AdvancedRepository {
  final HttpService _httpService = HttpService();

  Future<AdvancedQuestionModel> getBigQuestion(String selectedCulture) async {
    final data = await _httpService.get('${AppConstants.advancedQuestionEndpoint}/?culture=$selectedCulture');
    return AdvancedQuestionModel.fromJson(data);
  }

  Future<Map<String, dynamic>> submitAnswer(String questionId, String answer, Map<String, String> headers) async {
    return await _httpService.post(
      '${AppConstants.advancedQuestionEndpoint}/$questionId/answer/',
      {'user_answer': answer},
      headers: headers,
    );
  }
} 