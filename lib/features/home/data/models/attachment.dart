class Attachment {
  final String? movie_file;
  final String? movie_title;
  final String? movie_trailer;
  final String? movie_thumbnail;
  final String? movie_trailer_thumbnail;
  final String? cast_avatar;
  final String? tv_show_file;
  final String? tv_show_title;
  final String? tv_show_trailer;
  final String? tv_show_thumbnail;
  final String? tv_show_trailer_thumbnail;
  final String? avatar;
  final String? poster;
  Attachment({
    this.movie_file,
    this.movie_title,
    this.movie_trailer,
    this.movie_thumbnail,
    this.movie_trailer_thumbnail,
    this.cast_avatar,
    this.tv_show_file,
    this.tv_show_title,
    this.tv_show_trailer,
    this.tv_show_thumbnail,
    this.tv_show_trailer_thumbnail,
    this.avatar,
    this.poster,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      movie_file: json['movie_file']?.toString() ?? '',
      movie_title: json['movie_title']?.toString() ?? '',
      movie_trailer: json['movie_trailer']?.toString() ?? '',
      movie_thumbnail: json['movie_thumbnail']?.toString() ?? '',
      movie_trailer_thumbnail:
          json['movie_trailer_thumbnail']?.toString() ?? '',
      cast_avatar: json['cast_avatar']?.toString() ?? '',
      tv_show_file: json['tv_show_file']?.toString() ?? '',
      tv_show_title: json['tv_show_title']?.toString() ?? '',
      tv_show_trailer: json['tv_show_trailer']?.toString() ?? '',
      tv_show_thumbnail: json['tv_show_thumbnail']?.toString() ?? '',
      tv_show_trailer_thumbnail:
          json['tv_show_trailer_thumbnail']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? '',
      poster: json['poster']?.toString() ?? '',
    );
  }
}
