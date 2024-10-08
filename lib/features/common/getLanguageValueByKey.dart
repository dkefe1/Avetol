import 'package:avetol/features/home/data/models/localizedText.dart';

String getLanguageValueByKey(List<LocalizedText> listName, String language) {
  for (var item in listName) {
    if (item.key == language) {
      return item.value;
    }
  }
  return listName[0].value;
}
