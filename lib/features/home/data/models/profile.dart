import 'package:avetol/features/home/data/models/movieModel.dart';
import 'package:avetol/features/home/data/models/subscription.dart';
import 'package:avetol/features/home/data/models/tvShowModel.dart';
import 'package:avetol/features/home/data/models/user.dart';

class Profile {
  final User user;
  final List<Subscription> subscription;
  final List<dynamic> myList;

  Profile(
      {required this.user, required this.subscription, required this.myList});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
        user: User.fromJson(json['user'] ?? {}),
        subscription: (json['subscriptions'] as List<dynamic>?)
                ?.map((item) => Subscription.fromJson(item))
                .toList() ??
            [],
        myList: (json['myList'] as List<dynamic>?)?.map((item) {
              if (item.containsKey('seasons_count')) {
                return TvShowModel.fromJson(item);
              } else {
                return MovieModel.fromJson(item);
              }
            }).toList() ??
            []);
  }
}
