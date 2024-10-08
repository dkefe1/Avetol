class Content {
  final String id;
  final String tv_show_id;
  final String season_number;
  final String status;
  final String thumbnail;

  Content({
    required this.id,
    required this.tv_show_id,
    required this.status,
    required this.season_number,
    required this.thumbnail,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id']?.toString() ?? '',
      tv_show_id: json['tv_show_id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      season_number: json['season_number']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
    );
  }
}
