import 'package:avetol/features/home/data/models/localizedText.dart';

class Category {
  final String id;
  final List<LocalizedText> name;
  final List<LocalizedText> description;
  final String genre_id;
  final String color;
  final String color_formatted;

  Category(
      {required this.id,
      required this.name,
      required this.description,
      required this.genre_id,
      required this.color,
      required this.color_formatted});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
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
        color_formatted: json['color_formatted']?.toString() ?? '');
  }
}
