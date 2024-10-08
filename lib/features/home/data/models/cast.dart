import 'package:avetol/features/home/data/models/castModel.dart';
import 'package:avetol/features/home/data/models/movieModel.dart';
import 'package:avetol/features/home/data/models/tvShowModel.dart';

class Cast {
  final CastModel cast;
  final List<dynamic> works;

  Cast({required this.cast, required this.works});

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      cast: CastModel.fromJson(json['cast'] ?? {}),
      works: (json['works'] as List<dynamic>?)?.map((item) {
            if (item.containsKey('seasons_count')) {
              return TvShowModel.fromJson(item);
            } else {
              return MovieModel.fromJson(item);
            }
          }).toList() ??
          [],
    );
  }
}
