import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:avetol/core/constants.dart';
import 'package:avetol/core/globals.dart';
import 'package:avetol/core/services/sharedPreferences.dart';
import 'package:avetol/features/auth/signup/data/models/signup.dart';
import 'package:http/http.dart' as http;

class SignupRemoteDatasource {
  final prefs = PrefService();
  Future signupUser(Signup signup) async {
    var headersList = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}register");

    var body = {
      "email": signup.email,
      "password": signup.password,
      "phone": signup.phone,
      "first_name": signup.first_name,
      "last_name": signup.last_name,
      "dob": signup.dob
    };

    try {
      var response =
          await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = response.body;

      final data = json.decode(resBody);

      if (data['success']) {
        await prefs.storeToken(data['data']['token']);
        print("User ${data['message']}");
        print(data['data']);
      } else if (data['status'] == 500) {
        print("User already Exists");
        throw "User already Exists";
      } else {
        print(data['data'].toString());
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
      throw e.toString();
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
