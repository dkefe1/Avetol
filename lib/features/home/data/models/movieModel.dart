import 'package:avetol/features/home/data/models/attachment.dart';
import 'package:avetol/features/home/data/models/castModel.dart';
import 'package:avetol/features/home/data/models/category.dart';
import 'package:avetol/features/home/data/models/localizedText.dart';

class MovieModel {
  final String id;
  final String country_id;
  final List<LocalizedText> title;
  final List<LocalizedText> description;
  final String release_date;
  final String duration;
  final String is_premium;
  final String local_only;
  final String status;
  final String color;
  final Attachment attachments;
  final List<CastModel> casts;
  final List<Category> genres;

  MovieModel(
      {required this.id,
      required this.country_id,
      required this.title,
      required this.description,
      required this.release_date,
      required this.duration,
      required this.is_premium,
      required this.local_only,
      required this.status,
      required this.color,
      required this.attachments,
      required this.casts,
      required this.genres});

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
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
      color: json['color']?.toString() ?? '',
      attachments: Attachment.fromJson(json['attachments'] ?? {}),
      casts: (json['casts'] as List<dynamic>?)
              ?.map((item) => CastModel.fromJson(item))
              .toList() ??
          [],
      genres: (json['genres'] as List<dynamic>?)
              ?.map((item) => Category.fromJson(item))
              .toList() ??
          [],
    );
  }
}
