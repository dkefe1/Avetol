import 'package:avetol/features/home/data/models/favorites.dart';

abstract class CategoryEvent {}

class GetCategoryEvent extends CategoryEvent {}

class GetCategoryDetailEvent extends CategoryEvent {
  String categoryId;
  GetCategoryDetailEvent(this.categoryId);
}

abstract class MoviesEvent {}

class GetMoviesEvent extends MoviesEvent {
  String movieId;
  GetMoviesEvent(this.movieId);
}

abstract class TvShowEvent {}

class GetTvShowEvent extends TvShowEvent {
  String tvShowId;
  GetTvShowEvent(this.tvShowId);
}

abstract class EpisodesEvent {}

class GetEpisodesBySeasonId extends EpisodesEvent {
  String tvShowId;
  String seasonId;
  GetEpisodesBySeasonId(this.tvShowId, this.seasonId);
}

abstract class ProfileEvent {}

class GetProfileEvent extends ProfileEvent {}

class GetAvatarEvent extends ProfileEvent {}

abstract class LanguageEvent {}

class GetLanguageEvent extends LanguageEvent {}

abstract class SearchEvent {}

class GetSearchEvent extends SearchEvent {
  String searchTerm;
  GetSearchEvent(this.searchTerm);
}

abstract class HomePageEvent {}

class GetHomePageEvent extends HomePageEvent {}

abstract class CastEvent {}

class GetCastEvent extends CastEvent {
  String castId;
  GetCastEvent(this.castId);
}

abstract class FavoritesEvent {}

class PostFavoritesEvent extends FavoritesEvent {
  final Favorites favorites;
  PostFavoritesEvent(this.favorites);
}

class DelFavoritesEvent extends FavoritesEvent {
  final Favorites favorites;
  DelFavoritesEvent(this.favorites);
}
