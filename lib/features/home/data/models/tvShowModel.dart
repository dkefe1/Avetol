import 'package:avetol/features/home/data/models/attachment.dart';
import 'package:avetol/features/home/data/models/castModel.dart';
import 'package:avetol/features/home/data/models/category.dart';
import 'package:avetol/features/home/data/models/latestSeason.dart';
import 'package:avetol/features/home/data/models/localizedText.dart';

class TvShowModel {
  final String id;
  final String country_id;
  final List<LocalizedText> title;
  final List<LocalizedText> description;
  final String release_date;
  final String is_premium;
  final String local_only;
  final String status;
  final String color;
  final String seasons_count;
  final String episodes_count;
  final Attachment attachments;
  final LatestSeason latest_season;
  final List<Category> genres;
  final List<CastModel> casts;

  TvShowModel(
      {required this.id,
      required this.country_id,
      required this.title,
      required this.description,
      required this.release_date,
      required this.is_premium,
      required this.local_only,
      required this.status,
      required this.color,
      required this.seasons_count,
      required this.episodes_count,
      required this.attachments,
      required this.latest_season,
      required this.genres,
      required this.casts});

  factory TvShowModel.fromJson(Map<String, dynamic> json) {
    return TvShowModel(
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
        is_premium: json['is_premium']?.toString() ?? '',
        local_only: json['local_only']?.toString() ?? '',
        status: json['status']?.toString() ?? '',
        color: json['color']?.toString() ?? '',
        seasons_count: json['seasons_count']?.toString() ?? '',
        episodes_count: json['episodes_count']?.toString() ?? '',
        attachments: Attachment.fromJson(json['attachments'] ?? {}),
        latest_season: LatestSeason.fromJson(json['latest_season'] ?? {}),
        genres: (json['genres'] as List<dynamic>?)
                ?.map((item) => Category.fromJson(item))
                .toList() ??
            [],
        casts: (json['casts'] as List<dynamic>?)
                ?.map((item) => CastModel.fromJson(item))
                .toList() ??
            []);
  }
}
