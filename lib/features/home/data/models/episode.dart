import 'package:avetol/features/home/data/models/localizedText.dart';

class Episode {
  final String id;
  final String season_id;
  final List<LocalizedText> title;
  final List<LocalizedText> description;
  final String episode_number;
  final String duration;
  final String release_date;
  final String status;
  final String thumbnail;

  Episode(
      {required this.id,
      required this.season_id,
      required this.title,
      required this.description,
      required this.episode_number,
      required this.duration,
      required this.release_date,
      required this.status,
      required this.thumbnail});

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
        id: json['id']?.toString() ?? '',
        season_id: json['season_id']?.toString() ?? '',
        title: (json['title'] as List<dynamic>?)
                ?.map((item) => LocalizedText.fromJson(item))
                .toList() ??
            [],
        description: (json['description'] as List<dynamic>?)
                ?.map((item) => LocalizedText.fromJson(item))
                .toList() ??
            [],
        episode_number: json['episode_number']?.toString() ?? '',
        duration: json['duration']?.toString() ?? '',
        release_date: json['release_date']?.toString() ?? '',
        status: json['status']?.toString() ?? '',
        thumbnail: json['thumbnail']?.toString() ?? '');
  }
}
