class Season {
  final String id;
  final String tv_show_id;
  final String season_number;
  final String status;
  final String thumbnail;

  Season({
    required this.id,
    required this.tv_show_id,
    required this.season_number,
    required this.status,
    required this.thumbnail,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['id']?.toString() ?? '',
      tv_show_id: json['tv_show_id']?.toString() ?? '',
      season_number: json['season_number']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
    );
  }
}
