import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:avetol/core/constants.dart';
import 'package:avetol/core/globals.dart';
import 'package:avetol/core/services/sharedPreferences.dart';
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
import 'package:http/http.dart' as http;

class HomeRemoteDataSource {
  final prefs = PrefService();
  Future<List<Category>> getCategory() async {
    var token = await prefs.readToken();
    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse("${baseUrl}genres");
    var response = await http.get(url, headers: headersList);
    var resBody = response.body;
    final data = json.decode(resBody);
    try {
      if (response.statusCode == 200) {
        final List<dynamic> categoryList = data['data'];
        List<Category> category = categoryList.map((catJson) {
          return Category.fromJson(catJson);
        }).toList();
        return category;
      } else {
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<GenreDetail> getCategoryDetail(String categoryId) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse('${baseUrl}genres/${categoryId}');

    var response = await http.get(url, headers: headersList);

    var resBody = response.body;

    final data = json.decode(resBody);

    try {
      if (response.statusCode == 200) {
        final GenreDetail genreDetail = GenreDetail.fromJson(data['data']);
        return genreDetail;
      } else {
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<Movies> getMovies(String movieId) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse(
        '${baseUrl}movies/${movieId}?movie=1&ads=1&related=1&genres=1&casts=1');

    var response = await http.get(url, headers: headersList);

    var resBody = response.body;

    final data = json.decode(resBody);

    try {
      if (response.statusCode == 200) {
        final Movies movieInfo = Movies.fromJson(data['data']);
        return movieInfo;
      } else {
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<TvShow> getTvShow(String tvShowId) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse(
        '${baseUrl}tv-shows/${tvShowId}?tvShow=1&seasons=1&seasonId=59&casts=1&related=1&ads=1');

    var response = await http.get(url, headers: headersList);

    var resBody = response.body;

    final data = json.decode(resBody);

    try {
      if (response.statusCode == 200) {
        final TvShow tvShowInfo = TvShow.fromJson(data['data']);
        return tvShowInfo;
      } else {
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<TvShow> getEpisodesBySeasonId(String tvShowId, String seasonId) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse(
        '${baseUrl}tv-shows/${tvShowId}?tvShow=1&seasons=1&seasonId=${seasonId}&casts=1&related=1&ads=1');

    var response = await http.get(url, headers: headersList);

    var resBody = response.body;

    final data = json.decode(resBody);
    print(data['data'].toString());

    try {
      if (response.statusCode == 200) {
        final TvShow tvShowInfo = TvShow.fromJson(data['data']);
        return tvShowInfo;
      } else {
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<Profile> getProfile() async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse('${baseUrl}profile');

    var response = await http.get(url, headers: headersList);

    var resBody = response.body;

    final data = json.decode(resBody);

    try {
      if (response.statusCode == 200) {
        final Profile profileInfo = Profile.fromJson(data['data']);
        return profileInfo;
      } else {
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<List<Avatar>> getAvatar() async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse('${baseUrl}avatars');

    var response = await http.get(url, headers: headersList);

    var resBody = response.body;

    final data = json.decode(resBody);

    try {
      if (response.statusCode == 200) {
        final List<dynamic> avatarList = data['data'];
        List<Avatar> avatarInfoList = avatarList.map((avatarJson) {
          return Avatar.fromJson(avatarJson);
        }).toList();
        return avatarInfoList;
      } else {
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<List<Language>> getLanguage() async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse('${baseUrl}languages');

    var response = await http.get(url, headers: headersList);

    var resBody = response.body;

    final data = json.decode(resBody);

    try {
      if (response.statusCode == 200) {
        final List<dynamic> languageList = data['data'];
        List<Language> language = languageList.map((catJson) {
          return Language.fromJson(catJson);
        }).toList();
        return language;
      } else {
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<SearchList> search(String searchTerm) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse('${baseUrl}search?search=${searchTerm}');

    var response = await http.get(url, headers: headersList);

    var resBody = response.body;

    final data = json.decode(resBody);

    try {
      if (response.statusCode == 200) {
        final SearchList searchList = SearchList.fromJson(data['data']);
        return searchList;
      } else {
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<HomePage> getHomePage() async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse(
        '${baseUrl}home?popular=1&continue=1&trending=1&ads=1&tvShows=1&exclusive=1&original=1&genres=1');

    var response = await http.get(url, headers: headersList);

    var resBody = response.body;

    final data = json.decode(resBody);

    try {
      if (response.statusCode == 200) {
        final HomePage homepage = HomePage.fromJson(data['data']);
        return homepage;
      } else {
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<Cast> getCast(String castId) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse('${baseUrl}casts/${castId}?cast=1&works=1');

    var response = await http.get(url, headers: headersList);

    var resBody = response.body;

    final data = json.decode(resBody);

    try {
      if (response.statusCode == 200) {
        final Cast castInfo = Cast.fromJson(data['data']);
        return castInfo;
      } else {
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future addFavorites(Favorites favorites) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}favorites");

    var body = {
      'content_type': favorites.content_type,
      'content_id': favorites.content_id,
      'action_type': "ATTACH"
    };
    print(body.toString());

    try {
      var response =
          await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = response.body;
      final data = json.decode(resBody);
      print('Response status Code: ${response.statusCode}');
      print('Response header: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print("Added to My List!");
        print(data['data']);
      } else {
        print(data['data']);
        print(data.toString());
        print(data['status']);
        throw data['data'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future removeFavorites(Favorites favorites) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}favorites");

    var body = {
      'content_type': favorites.content_type,
      'content_id': favorites.content_id,
      'action_type': "DETACH"
    };

    try {
      var response =
          await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = response.body;
      final data = json.decode(resBody);

      if (response.statusCode == 200) {
        print("Removed from My List!");
        print(data['data']);
      } else {
        print(data['data']);
        print(data.toString());
        print(data['status']);
        throw data['data'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
