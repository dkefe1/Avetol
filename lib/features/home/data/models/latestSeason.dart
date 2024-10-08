import 'package:avetol/features/home/data/models/attachment.dart';

class LatestSeason {
  final String id;
  final String tv_show_id;
  final String season_number;
  final String status;
  final List<Attachment> attachments;

  LatestSeason(
      {required this.id,
      required this.tv_show_id,
      required this.season_number,
      required this.status,
      required this.attachments});

  factory LatestSeason.fromJson(Map<String, dynamic> json) {
    return LatestSeason(
        id: json['id']?.toString() ?? '',
        tv_show_id: json['tv_show_id']?.toString() ?? '',
        season_number: json['season_number']?.toString() ?? '',
        status: json['status']?.toString() ?? '',
        attachments: (json['attachments'] as List<dynamic>?)
                ?.map((item) => Attachment.fromJson(item))
                .toList() ??
            []);
  }
}
