import 'package:avetol/features/home/data/models/attachment.dart';

class Avatar {
  final String id;
  final String name;
  final Attachment attachments;

  Avatar({required this.id, required this.name, required this.attachments});

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        attachments: Attachment.fromJson(json['attachments'] ?? {}));
  }
}
