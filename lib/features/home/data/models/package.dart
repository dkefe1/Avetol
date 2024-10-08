import 'package:avetol/features/home/data/models/localizedText.dart';

class Package {
  final String id;
  final List<LocalizedText> name;
  final String data;
  final String price;
  final String duration;
  Package(
      {required this.id,
      required this.name,
      required this.data,
      required this.price,
      required this.duration});

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
        id: json['id']?.toString() ?? '',
        name: (json['name'] as List<dynamic>?)
                ?.map((item) => LocalizedText.fromJson(item))
                .toList() ??
            [],
        data: json['data']?.toString() ?? '',
        price: json['price']?.toString() ?? '',
        duration: json['duration']?.toString() ?? '');
  }
}
