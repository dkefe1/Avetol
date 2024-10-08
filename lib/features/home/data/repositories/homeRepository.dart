import 'package:avetol/features/home/data/dataSources/homeDataSource.dart';
import 'package:avetol/features/home/data/models/avatar.dart';
import 'package:avetol/features/home/data/models/cast.dart';
import 'package:avetol/features/home/data/models/category.dart';
import 'package:avetol/features/home/data/models/favorites.dart';
import 'package:avetol/features/home/data/models/genreDetail.dart';
import 'package:avetol/features/home/data/models/homePage.dart';
import 'package:avetol/features/home/data/models/language.dart';
import 'package:avetol/features/home/data/models/movies.dart';
import 'package:avetol/features/home/data/models/profile.dart';
import 'package:avetol/features/home/data/models/searchList.dart';
import 'package:avetol/features/home/data/models/tvShow.dart';

class HomeRepository {
  HomeRemoteDataSource homeRemoteDataSource;
  HomeRepository(this.homeRemoteDataSource);
  Future<List<Category>> getCategory() async {
    try {
      final category = await homeRemoteDataSource.getCategory();
      return category;
    } catch (e) {
      throw e;
    }
  }

  Future<GenreDetail> getCategoryDetail(String categoryId) async {
    try {
      final categoryDetail =
          await homeRemoteDataSource.getCategoryDetail(categoryId);
      return categoryDetail;
    } catch (e) {
      throw e;
    }
  }

  Future<Movies> getMovies(String movieId) async {
    try {
      final movieInfo = await homeRemoteDataSource.getMovies(movieId);
      return movieInfo;
    } catch (e) {
      throw e;
    }
  }

  Future<TvShow> getTvShow(String tvShowId) async {
    try {
      final tvShowInfo = await homeRemoteDataSource.getTvShow(tvShowId);
      return tvShowInfo;
    } catch (e) {
      throw e;
    }
  }

  Future<TvShow> getEpisodesBySeasonId(String tvShowId, String seasonId) async {
    try {
      final episodeInfo =
          await homeRemoteDataSource.getEpisodesBySeasonId(tvShowId, seasonId);
      return episodeInfo;
    } catch (e) {
      throw e;
    }
  }

  Future<Profile> getProfile() async {
    try {
      final profileInfo = await homeRemoteDataSource.getProfile();
      return profileInfo;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Avatar>> getAvatar() async {
    try {
      final avatarInfo = await homeRemoteDataSource.getAvatar();
      return avatarInfo;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Language>> getLanguage() async {
    try {
      final language = await homeRemoteDataSource.getLanguage();
      return language;
    } catch (e) {
      throw e;
    }
  }

  Future<SearchList> search(String searchTerm) async {
    try {
      final result = await homeRemoteDataSource.search(searchTerm);
      return result;
    } catch (e) {
      throw e;
    }
  }

  Future<HomePage> getHomePage() async {
    try {
      final homePage = await homeRemoteDataSource.getHomePage();
      return homePage;
    } catch (e) {
      throw e;
    }
  }

  Future<Cast> getCast(String castId) async {
    try {
      final castInfo = await homeRemoteDataSource.getCast(castId);
      return castInfo;
    } catch (e) {
      throw e;
    }
  }

  Future addFavorites(Favorites favorites) async {
    try {
      await homeRemoteDataSource.addFavorites(favorites);
    } catch (e) {
      throw e;
    }
  }

  Future removeFavorites(Favorites favorites) async {
    try {
      await homeRemoteDataSource.removeFavorites(favorites);
    } catch (e) {
      throw e;
    }
  }
}
