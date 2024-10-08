import 'package:avetol/features/home/data/models/ad.dart';
import 'package:avetol/features/home/data/models/castModel.dart';
import 'package:avetol/features/home/data/models/category.dart';
import 'package:avetol/features/home/data/models/movieModel.dart';
import 'package:avetol/features/home/data/models/related.dart';

class Movies {
  final MovieModel movie;
  final Ad ads;
  final List<Related> related;
  final List<Category> genres;
  final List<CastModel> casts;

  Movies({
    required this.movie,
    required this.ads,
    required this.related,
    required this.genres,
    required this.casts,
  });

  factory Movies.fromJson(Map<String, dynamic> json) {
    return Movies(
        movie: MovieModel.fromJson(json['movie'] ?? {}),
        ads: Ad.fromJson(json['ads'] ?? {}),
        related: (json['related'] as List<dynamic>?)
                ?.map((item) => Related.fromJson(item))
                .toList() ??
            [],
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
