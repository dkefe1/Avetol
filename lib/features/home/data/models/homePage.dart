import 'package:avetol/features/home/data/models/ad.dart';
import 'package:avetol/features/home/data/models/category.dart';
import 'package:avetol/features/home/data/models/movieModel.dart';
import 'package:avetol/features/home/data/models/tvShowModel.dart';

class HomePage {
  final List<dynamic> popular;
  final List<dynamic> continueWatching;
  final List<dynamic> trending;
  final List<Ad> ads;
  final List<TvShowModel> tvShows;
  final List<dynamic> exclusive;
  final List<dynamic> original;
  final List<Category> genres;

  HomePage(
      {required this.popular,
      required this.continueWatching,
      required this.trending,
      required this.ads,
      required this.tvShows,
      required this.exclusive,
      required this.original,
      required this.genres});

  factory HomePage.fromJson(Map<String, dynamic> json) {
    return HomePage(
        popular: (json['popular'] as List<dynamic>?)?.map((item) {
              if (item.containsKey('seasons_count')) {
                return TvShowModel.fromJson(item);
              } else {
                return MovieModel.fromJson(item);
              }
            }).toList() ??
            [],
        continueWatching: (json['continue'] as List<dynamic>?)?.map((item) {
              if (item.containsKey('seasons_count')) {
                return TvShowModel.fromJson(item);
              } else {
                return MovieModel.fromJson(item);
              }
            }).toList() ??
            [],
        trending: (json['trending'] as List<dynamic>?)?.map((item) {
              if (item.containsKey('seasons_count')) {
                return TvShowModel.fromJson(item);
              } else {
                return MovieModel.fromJson(item);
              }
            }).toList() ??
            [],
        ads: (json['ads'] as List<dynamic>?)
                ?.map((item) => Ad.fromJson(item))
                .toList() ??
            [],
        tvShows: (json['tvShows'] as List<dynamic>?)
                ?.map((item) => TvShowModel.fromJson(item))
                .toList() ??
            [],
        exclusive: (json['exclusive'] as List<dynamic>?)?.map((item) {
              if (item.containsKey('seasons_count')) {
                return TvShowModel.fromJson(item);
              } else {
                return MovieModel.fromJson(item);
              }
            }).toList() ??
            [],
        original: (json['original'] as List<dynamic>?)?.map((item) {
              if (item.containsKey('seasons_count')) {
                return TvShowModel.fromJson(item);
              } else {
                return MovieModel.fromJson(item);
              }
            }).toList() ??
            [],
        genres: (json['genres'] as List<dynamic>?)
                ?.map((item) => Category.fromJson(item))
                .toList() ??
            []);
  }
}
