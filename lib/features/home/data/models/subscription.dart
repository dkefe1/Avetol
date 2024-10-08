import 'package:avetol/features/home/data/models/package.dart';

class Subscription {
  final String id;
  final String user_id;
  final String subscription_id;
  final String start_date;
  final String end_date;
  final Package subscription;

  Subscription(
      {required this.id,
      required this.user_id,
      required this.subscription_id,
      required this.start_date,
      required this.end_date,
      required this.subscription});

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
        id: json['id']?.toString() ?? '',
        user_id: json['user_id']?.toString() ?? '',
        subscription_id: json['subscription_id']?.toString() ?? '',
        start_date: json['start_date']?.toString() ?? '',
        end_date: json['end_date']?.toString() ?? '',
        subscription: Package.fromJson(json['subscription'] ?? {}));
  }
}
