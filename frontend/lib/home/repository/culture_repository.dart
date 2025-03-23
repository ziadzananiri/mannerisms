import 'package:mannerisms/home/model/culture_model.dart';

class CultureRepository {
  List<CultureModel> getCultures() {
    return [
      CultureModel(
        name: 'Western',
        description: 'North American and European cultural norms',
        tag: 'western',
      ),
      CultureModel(
        name: 'East Asian',
        description: 'Chinese, Japanese, and Korean cultural norms',
        tag: 'east_asian',
      ),
      CultureModel(
        name: 'South Asian',
        description: 'Indian, Pakistani, and Bangladeshi cultural norms',
        tag: 'south_asian',
      ),
      CultureModel(
        name: 'Middle Eastern',
        description: 'Arabic, Persian, and Turkish cultural norms',
        tag: 'middle_eastern',
      ),
    ];
  }
} 