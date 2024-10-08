import 'package:avetol/features/home/data/models/ad.dart';
import 'package:avetol/features/home/data/models/castModel.dart';
import 'package:avetol/features/home/data/models/episode.dart';
import 'package:avetol/features/home/data/models/related.dart';
import 'package:avetol/features/home/data/models/season.dart';
import 'package:avetol/features/home/data/models/tvShowModel.dart';

class TvShow {
  final TvShowModel tvshow;
  final List<Season> seasons;
  final List<Episode> episodes;
  final List<Related> related;
  final List<CastModel> casts;
  final List<Ad> ads;

  TvShow({
    required this.tvshow,
    required this.seasons,
    required this.episodes,
    required this.related,
    required this.casts,
    required this.ads,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      tvshow: TvShowModel.fromJson(json['tv_show'] ?? {}),
      seasons: (json['seasons'] as List<dynamic>?)
              ?.map((item) => Season.fromJson(item))
              .toList() ??
          [],
      episodes: (json['episodes'] as List<dynamic>?)
              ?.map((item) => Episode.fromJson(item))
              .toList() ??
          [],
      related: (json['related'] as List<dynamic>?)
              ?.map((item) => Related.fromJson(item))
              .toList() ??
          [],
      casts: (json['casts'] as List<dynamic>?)
              ?.map((item) => CastModel.fromJson(item))
              .toList() ??
          [],
      ads: (json['ads'] as List<dynamic>?)
              ?.map((item) => Ad.fromJson(item))
              .toList() ??
          [],
    );
  }
}
