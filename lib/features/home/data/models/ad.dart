import 'package:avetol/features/home/data/models/content.dart';
import 'package:avetol/features/home/data/models/localizedText.dart';

class Ad {
  final String id;
  final List<LocalizedText> title;
  final List<LocalizedText> description;
  final String start_date;
  final String end_date;
  final String status;
  final String poster;
  final Content content;

  Ad(
      {required this.id,
      required this.title,
      required this.description,
      required this.start_date,
      required this.end_date,
      required this.status,
      required this.poster,
      required this.content});

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
        id: json['id']?.toString() ?? '',
        title: (json['title'] as List<dynamic>?)
                ?.map((item) => LocalizedText.fromJson(item))
                .toList() ??
            [],
        description: (json['description'] as List<dynamic>?)
                ?.map((item) => LocalizedText.fromJson(item))
                .toList() ??
            [],
        start_date: json['start_date']?.toString() ?? '',
        end_date: json['end_date']?.toString() ?? '',
        status: json['status']?.toString() ?? '',
        poster: json['poster']?.toString() ?? '',
        content: Content.fromJson(json['content'] ?? {}));
  }
}
