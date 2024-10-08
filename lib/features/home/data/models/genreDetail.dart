import 'package:avetol/features/home/data/models/localizedText.dart';
import 'package:avetol/features/home/data/models/movieModel.dart';
import 'package:avetol/features/home/data/models/tvShowModel.dart';

class GenreDetail {
  final String id;
  final List<LocalizedText> name;
  final List<LocalizedText> description;
  final String genre_id;
  final String color;
  final String color_formatted;
  final List<TvShowModel> tv_shows;
  final List<MovieModel> movies;

  GenreDetail(
      {required this.id,
      required this.name,
      required this.description,
      required this.genre_id,
      required this.color,
      required this.color_formatted,
      required this.tv_shows,
      required this.movies});

  factory GenreDetail.fromJson(Map<String, dynamic> json) {
    return GenreDetail(
      id: json['id']?.toString() ?? '',
      name: (json['name'] as List<dynamic>?)
              ?.map((item) => LocalizedText.fromJson(item))
              .toList() ??
          [],
      description: (json['description'] as List<dynamic>?)
              ?.map((item) => LocalizedText.fromJson(item))
              .toList() ??
          [],
      genre_id: json['genre_id']?.toString() ?? '',
      color: json['color']?.toString() ?? '',
      color_formatted: json['color_formatted']?.toString() ?? '',
      tv_shows: (json['tv_shows'] as List<dynamic>?)
              ?.map((item) => TvShowModel.fromJson(item))
              .toList() ??
          [],
      movies: (json['movies'] as List<dynamic>?)
              ?.map((item) => MovieModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}
