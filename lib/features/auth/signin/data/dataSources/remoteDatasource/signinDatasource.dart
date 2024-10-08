import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:avetol/core/constants.dart';
import 'package:avetol/core/globals.dart';
import 'package:avetol/core/services/sharedPreferences.dart';
import 'package:avetol/features/auth/signin/data/models/changeForgotPassword.dart';
import 'package:avetol/features/auth/signin/data/models/changePassword.dart';
import 'package:avetol/features/auth/signin/data/models/otp.dart';
import 'package:avetol/features/auth/signin/data/models/forgotPasswordRequest.dart';
import 'package:avetol/features/auth/signin/data/models/signin.dart';
import 'package:avetol/features/auth/signin/data/models/updateAvatar.dart';
import 'package:avetol/features/auth/signin/data/models/updateProfile.dart';
import 'package:http/http.dart' as http;

class SigninRemoteDatasource {
  final prefs = PrefService();
  Future signinUser(Signin signin) async {
    var headersList = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}login");

    var body = signin.identifier.contains('@')
        ? {"email": signin.identifier, "password": signin.password}
        : {"phone": signin.identifier, "password": signin.password};
    print('');
    print(body.toString());
    print('');
    try {
      var response =
          await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = response.body;
      final data = json.decode(resBody);

      if (response.statusCode == 200) {
        await prefs.storeToken(data['data']['token']);
        print("Login Successful!");
        print(data['data']);
      } else if (response.statusCode == 403) {
        throw "Please enter correct login credential";
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

  Future logout() async {
    var token = await prefs.readToken();
    var headersList = {
      // 'Accept': '*/*',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}logout");

    try {
      var response = await http.delete(url, headers: headersList);

      if (response.statusCode == 200) {
        final resBody = response.body;
        final data = json.decode(resBody);
        print(data.toString());
      } else if (response.statusCode == 500) {
        throw Exception('Internal Server Error. Please try again later.');
      } else {
        final resBody = response.body;
        final data = json.decode(resBody);
        throw Exception(data['error']);
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw 'Timeout Error: $e';
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw 'Socket Error: $e';
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw 'Format Error: $e';
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw 'Client Exception Socket Error: $e';
    } on Error catch (e) {
      print('Error: $e');
      throw 'Error: $e';
    }
  }

  Future forgotPassword(ForgotPassword forgotPassword) async {
    var headersList = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}forgot-password");

    var body = {
      'phone': forgotPassword.phone,
    };
    print(body.toString());

    try {
      var response =
          await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = response.body;
      final data = json.decode(resBody);
      print(data.toString());

      if (response.statusCode == 200) {
        print("OTP sent Successfully!");
        print(data['data']);
      } else if (response.statusCode == 404) {
        throw "User Not Found.";
      } else {
        print(data.toString());
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

  Future otpVerification(OTP otp) async {
    var headersList = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}verify-otp");

    var body = {
      'phone': otp.phone,
      'code': otp.code,
    };

    print(body.toString());

    try {
      var response =
          await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = response.body;
      final data = json.decode(resBody);

      if (response.statusCode == 200) {
        print("Otp Verified!");
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

  Future changeForgotPassword(ChangeForgotPassword changeForgotPassword) async {
    var headersList = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}set-forgot-password");

    var body = {
      'phone': changeForgotPassword.phone,
      'password': changeForgotPassword.password,
      'password_confirmation': changeForgotPassword.password_confirmation
    };

    try {
      var response =
          await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = response.body;
      final data = json.decode(resBody);

      if (response.statusCode == 200) {
        print("Password Reset Successful!");
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

  Future changePassword(ChangePassword changePassword) async {
    var token = await prefs.readToken();
    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}change-password");

    var body = {
      'password': changePassword.password,
      'new_password': changePassword.new_password,
      'new_password_confirmation': changePassword.new_password_confirmation
    };
    print(body.toString());

    try {
      var response =
          await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = response.body;
      final data = json.decode(resBody);

      if (response.statusCode == 200) {
        print("Password Changed Successful!");
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

  Future updateProfile(UpdateProfile updateProfile) async {
    var token = await prefs.readToken();
    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}profile");

    var body = {
      'first_name': updateProfile.first_name,
      'last_name': updateProfile.last_name,
      'email': updateProfile.email,
      'dob': updateProfile.dob,
      '_method': "PATCH"
    };

    try {
      var response =
          await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = response.body;
      final data = json.decode(resBody);

      if (response.statusCode == 200) {
        print("Profile Updated Successful!");
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

  Future updateAvatar(UpdateAvatar updateAvatar) async {
    var token = await prefs.readToken();
    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}update-profile");

    var body = {
      'avatar_id': updateAvatar.avatar_id,
      '_method': "PATCH",
    };
    print(body.toString());
    try {
      var response =
          await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = response.body;
      final data = json.decode(resBody);

      if (response.statusCode == 200) {
        print("Avatar Updated Successful!");
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
