import 'package:avetol/features/home/data/models/attachment.dart';
import 'package:avetol/features/home/data/models/localizedText.dart';
import 'package:avetol/features/home/data/models/role.dart';

class CastModel {
  final String id;
  final List<LocalizedText> name;
  final List<LocalizedText> description;
  final Attachment attachments;
  final Role role;

  CastModel({
    required this.id,
    required this.name,
    required this.description,
    required this.attachments,
    required this.role,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      id: json['id']?.toString() ?? '',
      name: (json['name'] as List<dynamic>?)
              ?.map((item) => LocalizedText.fromJson(item))
              .toList() ??
          [],
      description: (json['description'] as List<dynamic>?)
              ?.map((item) => LocalizedText.fromJson(item))
              .toList() ??
          [],
      attachments: Attachment.fromJson(json['attachments'] ?? {}),
      role: Role.fromJson(json['role'] ?? {}),
    );
  }
}
