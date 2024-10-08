import 'package:avetol/features/home/data/models/attachment.dart';
import 'package:avetol/features/home/data/models/localizedText.dart';

class Related {
  final String id;
  final String country_id;
  final List<LocalizedText> title;
  final List<LocalizedText> description;
  final String release_date;
  final String duration;
  final String is_premium;
  final String local_only;
  final String status;
  final Attachment attachments;
  final String file;

  Related(
      {required this.id,
      required this.country_id,
      required this.title,
      required this.description,
      required this.release_date,
      required this.duration,
      required this.is_premium,
      required this.local_only,
      required this.status,
      required this.attachments,
      required this.file});

  factory Related.fromJson(Map<String, dynamic> json) {
    return Related(
        id: json['id']?.toString() ?? '',
        country_id: json['country_id']?.toString() ?? '',
        title: (json['title'] as List<dynamic>?)
                ?.map((item) => LocalizedText.fromJson(item))
                .toList() ??
            [],
        description: (json['description'] as List<dynamic>?)
                ?.map((item) => LocalizedText.fromJson(item))
                .toList() ??
            [],
        release_date: json['release_date']?.toString() ?? '',
        duration: json['duration']?.toString() ?? '',
        is_premium: json['is_premium']?.toString() ?? '',
        local_only: json['local_only']?.toString() ?? '',
        status: json['status']?.toString() ?? '',
        attachments: Attachment.fromJson(json['attachments'] ?? {}),
        file: json['file']?.toString() ?? '');
  }
}
