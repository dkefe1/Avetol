import 'package:avetol/features/guidelines/data/models/helpModel.dart';
import 'package:avetol/features/home/data/models/localizedText.dart';

class Guidelines {
  final List<LocalizedText> privacy_policy;
  final List<Help> help;
  final List<LocalizedText> terms_and_conditions;
  final List<LocalizedText> about;
  Guidelines(
      {required this.privacy_policy,
      required this.help,
      required this.terms_and_conditions,
      required this.about});

  factory Guidelines.fromJson(Map<String, dynamic> json) {
    return Guidelines(
        privacy_policy: (json['privacy_policy'] as List<dynamic>?)
                ?.map((item) => LocalizedText.fromJson(item))
                .toList() ??
            [],
        help: (json['help'] as List<dynamic>?)
                ?.map((item) => Help.fromJson(item))
                .toList() ??
            [],
        terms_and_conditions: (json['terms_and_conditions'] as List<dynamic>?)
                ?.map((item) => LocalizedText.fromJson(item))
                .toList() ??
            [],
        about: (json['about'] as List<dynamic>?)
                ?.map((item) => LocalizedText.fromJson(item))
                .toList() ??
            []);
  }
}
