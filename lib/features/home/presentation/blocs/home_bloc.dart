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
import 'package:avetol/features/home/data/repositories/homeRepository.dart';
import 'package:avetol/features/home/presentation/blocs/home_event.dart';
import 'package:avetol/features/home/presentation/blocs/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  HomeRepository homeRepository;
  CategoryBloc(this.homeRepository) : super(CategoryInitialState()) {
    on<GetCategoryEvent>(_onGetCategoryEvent);
    on<GetCategoryDetailEvent>(_onGetCategoryDetailEvent);
  }

  void _onGetCategoryEvent(GetCategoryEvent event, Emitter emit) async {
    emit(CategoryLoadingState());
    try {
      List<Category> category = await homeRepository.getCategory();
      emit(CategorySuccessfulState(category));
    } catch (e) {
      emit(CategoryFailureState(e.toString()));
    }
  }

  void _onGetCategoryDetailEvent(
      GetCategoryDetailEvent event, Emitter emit) async {
    emit(CategoryDetailLoadingState());
    try {
      GenreDetail categoryDetail =
          await homeRepository.getCategoryDetail(event.categoryId);
      emit(CategoryDetailSuccessfulState(categoryDetail));
    } catch (e) {
      emit(CategoryDetailFailureState(e.toString()));
    }
  }
}

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  HomeRepository homeRepository;
  MoviesBloc(this.homeRepository) : super(MoviesInitialState()) {
    on<GetMoviesEvent>(_onGetMoviesEvent);
  }

  void _onGetMoviesEvent(GetMoviesEvent event, Emitter emit) async {
    emit(MoviesLoadingState());

    try {
      Movies movies = await homeRepository.getMovies(event.movieId);
      emit(MoviesSuccessfulState(movies));
    } catch (e) {
      emit(MoviesFailureState(e.toString()));
    }
  }
}

class TvShowBloc extends Bloc<TvShowEvent, TvShowState> {
  HomeRepository homeRepository;
  TvShowBloc(this.homeRepository) : super(TvShowInitialState()) {
    on<GetTvShowEvent>(_onGetTvShowEvent);
  }

  void _onGetTvShowEvent(GetTvShowEvent event, Emitter emit) async {
    emit(TvShowLoadingState());
    try {
      TvShow tvShow = await homeRepository.getTvShow(event.tvShowId);
      emit(TvShowSuccessfulState(tvShow));
    } catch (e) {
      emit(TvShowFailureState(e.toString()));
    }
  }
}

class EpisodesBloc extends Bloc<EpisodesEvent, EpisodesState> {
  HomeRepository homeRepository;
  EpisodesBloc(this.homeRepository) : super(EpisodesInitialState()) {
    on<GetEpisodesBySeasonId>(_onGetEpisodesBySeasonId);
  }
  void _onGetEpisodesBySeasonId(
      GetEpisodesBySeasonId event, Emitter emit) async {
    emit(EpisodesLoadingState());
    try {
      TvShow tvShow = await homeRepository.getEpisodesBySeasonId(
          event.tvShowId, event.seasonId);
      emit(EpisodesSuccessfulState(tvShow));
    } catch (e) {
      emit(EpisodesFailureState(e.toString()));
    }
  }
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  HomeRepository homeRepository;
  ProfileBloc(this.homeRepository) : super(ProfileInitialState()) {
    on<GetProfileEvent>(_onGetProfileEvent);
    on<GetAvatarEvent>(_onGetAvatarEvent);
  }

  void _onGetProfileEvent(GetProfileEvent event, Emitter emit) async {
    emit(ProfileLoadingState());

    try {
      Profile profile = await homeRepository.getProfile();
      emit(ProfileSuccessfulState(profile));
    } catch (e) {
      emit(ProfileFailureState(e.toString()));
    }
  }

  void _onGetAvatarEvent(GetAvatarEvent event, Emitter emit) async {
    emit(AvatarLoadingState());

    try {
      List<Avatar> avatar = await homeRepository.getAvatar();
      emit(AvatarSuccessfulState(avatar));
    } catch (e) {
      emit(AvatarFailureState(e.toString()));
    }
  }
}

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  HomeRepository homeRepository;
  LanguageBloc(this.homeRepository) : super(LanguageInitialState()) {
    on<GetLanguageEvent>(_onGetLanguageEvent);
  }

  void _onGetLanguageEvent(GetLanguageEvent event, Emitter emit) async {
    emit(LanguageLoadingState());
    try {
      List<Language> language = await homeRepository.getLanguage();
      emit(LanguageSuccessfulState(language));
    } catch (e) {
      emit(LanguageFailureState(e.toString()));
    }
  }
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  HomeRepository homeRepository;
  SearchBloc(this.homeRepository) : super(SearchInitialState()) {
    on<GetSearchEvent>(_onGetSearchEvent);
  }

  void _onGetSearchEvent(GetSearchEvent event, Emitter emit) async {
    emit(SearchLoadingState());
    try {
      SearchList searchList = await homeRepository.search(event.searchTerm);
      emit(SearchSuccessfulState(searchList));
    } catch (e) {
      emit(SearchFailureState(e.toString()));
    }
  }
}

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomeRepository homeRepository;
  HomePageBloc(this.homeRepository) : super(HomePageInitialState()) {
    on<GetHomePageEvent>(_onGetHomePageEvent);
  }

  void _onGetHomePageEvent(GetHomePageEvent event, Emitter emit) async {
    emit(HomePageLoadingState());
    try {
      HomePage homePage = await homeRepository.getHomePage();
      emit(HomePageSuccessfulState(homePage));
    } catch (e) {
      emit(HomePageFailureState(e.toString()));
    }
  }
}

class CastBloc extends Bloc<CastEvent, CastState> {
  HomeRepository homeRepository;
  CastBloc(this.homeRepository) : super(CastInitialState()) {
    on<GetCastEvent>(_onGetCastEvent);
  }

  void _onGetCastEvent(GetCastEvent event, Emitter emit) async {
    emit(CastLoadingState());
    try {
      Cast castInfo = await homeRepository.getCast(event.castId);
      emit(CastSuccessfulState(castInfo));
    } catch (e) {
      emit(CastFailureState(e.toString()));
    }
  }
}

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  HomeRepository homeRepository;
  FavoritesBloc(this.homeRepository) : super(FavoritesInitialState()) {
    on<PostFavoritesEvent>(_onPostFavoritesEvent);
    on<DelFavoritesEvent>(_onDelFavoritesEvent);
  }

  void _onPostFavoritesEvent(PostFavoritesEvent event, Emitter emit) async {
    emit(FavoritesLoadingState());
    try {
      await homeRepository.addFavorites(event.favorites);
      emit(FavoritesSuccessfulState());
    } catch (e) {
      emit(FavoritesFailureState(e.toString()));
    }
  }

  void _onDelFavoritesEvent(DelFavoritesEvent event, Emitter emit) async {
    emit(RemoveFavoritesLoadingState());
    try {
      await homeRepository.removeFavorites(event.favorites);
      emit(RemoveFavoritesSuccessfulState());
    } catch (e) {
      emit(RemoveFavoritesFailureState(e.toString()));
    }
  }
}
