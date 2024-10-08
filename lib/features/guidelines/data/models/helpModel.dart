import 'package:avetol/features/home/data/models/localizedText.dart';

class Help {
  final List<LocalizedText> question;
  final List<LocalizedText> answer;

  Help({required this.question, required this.answer});

  factory Help.fromJson(Map<String, dynamic> json) {
    return Help(
        question: (json['question'] as List<dynamic>?)
                ?.map((item) => LocalizedText.fromJson(item))
                .toList() ??
            [],
        answer: (json['answer'] as List<dynamic>?)
                ?.map((item) => LocalizedText.fromJson(item))
                .toList() ??
            []);
  }
}
