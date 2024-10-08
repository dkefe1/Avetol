import 'package:avetol/features/home/data/models/avatar.dart';
import 'package:avetol/features/home/data/models/cast.dart';
import 'package:avetol/features/home/data/models/category.dart';
import 'package:avetol/features/home/data/models/genreDetail.dart';
import 'package:avetol/features/home/data/models/homePage.dart';
import 'package:avetol/features/home/data/models/language.dart';
import 'package:avetol/features/home/data/models/movies.dart';
import 'package:avetol/features/home/data/models/profile.dart';
import 'package:avetol/features/home/data/models/searchList.dart';
import 'package:avetol/features/home/data/models/tvShow.dart';

abstract class CategoryState {}

class CategoryInitialState extends CategoryState {}

class CategoryLoadingState extends CategoryState {}

class CategorySuccessfulState extends CategoryState {
  final List<Category> category;
  CategorySuccessfulState(this.category);
}

class CategoryFailureState extends CategoryState {
  final String error;
  CategoryFailureState(this.error);
}

class CategoryDetailLoadingState extends CategoryState {}

class CategoryDetailSuccessfulState extends CategoryState {
  final GenreDetail categoryDetail;
  CategoryDetailSuccessfulState(this.categoryDetail);
}

class CategoryDetailFailureState extends CategoryState {
  final String error;
  CategoryDetailFailureState(this.error);
}

abstract class MoviesState {}

class MoviesInitialState extends MoviesState {}

class MoviesLoadingState extends MoviesState {}

class MoviesSuccessfulState extends MoviesState {
  final Movies movies;
  MoviesSuccessfulState(this.movies);
}

class MoviesFailureState extends MoviesState {
  final String error;
  MoviesFailureState(this.error);
}

abstract class TvShowState {}

class TvShowInitialState extends TvShowState {}

class TvShowLoadingState extends TvShowState {}

class TvShowSuccessfulState extends TvShowState {
  final TvShow tvShow;
  TvShowSuccessfulState(this.tvShow);
}

class TvShowFailureState extends TvShowState {
  final String error;
  TvShowFailureState(this.error);
}

abstract class EpisodesState {}

class EpisodesInitialState extends EpisodesState {}

class EpisodesLoadingState extends EpisodesState {}

class EpisodesSuccessfulState extends EpisodesState {
  final TvShow tvShow;
  EpisodesSuccessfulState(this.tvShow);
}

class EpisodesFailureState extends EpisodesState {
  final String error;
  EpisodesFailureState(this.error);
}

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessfulState extends ProfileState {
  final Profile profile;
  ProfileSuccessfulState(this.profile);
}

class ProfileFailureState extends ProfileState {
  final String error;
  ProfileFailureState(this.error);
}

class AvatarLoadingState extends ProfileState {}

class AvatarSuccessfulState extends ProfileState {
  final List<Avatar> avatar;
  AvatarSuccessfulState(this.avatar);
}

class AvatarFailureState extends ProfileState {
  final String error;
  AvatarFailureState(this.error);
}

abstract class LanguageState {}

class LanguageInitialState extends LanguageState {}

class LanguageLoadingState extends LanguageState {}

class LanguageSuccessfulState extends LanguageState {
  final List<Language> language;
  LanguageSuccessfulState(this.language);
}

class LanguageFailureState extends LanguageState {
  final String error;
  LanguageFailureState(this.error);
}

abstract class SearchState {}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchSuccessfulState extends SearchState {
  final SearchList searchList;
  SearchSuccessfulState(this.searchList);
}

class SearchFailureState extends SearchState {
  final String error;
  SearchFailureState(this.error);
}

abstract class HomePageState {}

class HomePageInitialState extends HomePageState {}

class HomePageLoadingState extends HomePageState {}

class HomePageSuccessfulState extends HomePageState {
  final HomePage homePage;

  HomePageSuccessfulState(this.homePage);
}

class HomePageFailureState extends HomePageState {
  final String error;
  HomePageFailureState(this.error);
}

abstract class CastState {}

class CastInitialState extends CastState {}

class CastLoadingState extends CastState {}

class CastSuccessfulState extends CastState {
  final Cast castInfo;
  CastSuccessfulState(this.castInfo);
}

class CastFailureState extends CastState {
  final String error;
  CastFailureState(this.error);
}

abstract class FavoritesState {}

class FavoritesInitialState extends FavoritesState {}

class FavoritesLoadingState extends FavoritesState {}

class FavoritesSuccessfulState extends FavoritesState {}

class FavoritesFailureState extends FavoritesState {
  final String error;
  FavoritesFailureState(this.error);
}

class RemoveFavoritesLoadingState extends FavoritesState {}

class RemoveFavoritesSuccessfulState extends FavoritesState {}

class RemoveFavoritesFailureState extends FavoritesState {
  final String error;
  RemoveFavoritesFailureState(this.error);
}
