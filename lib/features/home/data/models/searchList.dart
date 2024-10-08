import 'package:avetol/features/home/data/models/movieModel.dart';
import 'package:avetol/features/home/data/models/tvShowModel.dart';

class SearchList {
  final List<MovieModel> movies;
  final List<TvShowModel> tvShows;

  SearchList({required this.movies, required this.tvShows});

  factory SearchList.fromJson(Map<String, dynamic> json) {
    return SearchList(
      movies: (json['movies'] as List<dynamic>?)
              ?.map((item) => MovieModel.fromJson(item))
              .toList() ??
          [],
      tvShows: (json['tvShows'] as List<dynamic>?)
              ?.map((item) => TvShowModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}
