import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart' show required;
import 'package:flutter/services.dart';
import '../app_config.dart';
import '../utils/dialogs.dart';
import '../utils/session.dart';

class AuthAPI {
  final _session = Session();

  Future<bool> register(BuildContext context,
      {@required String username,
      @required String email,
      @required String password}) async {
    try {
      final url = "${AppConfig.apiHost}/auth/register";

      final response = await http.post(
        url,
        body: {"username": username, "email": email, "password": password},
      );

      final parsed = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final token = parsed['accessToken'] as String;
        final expiresIn = parsed['expiresIn'] as int;
        await _session.set(token, expiresIn);
        return true;
      } else if (response.statusCode == 500) {
        throw PlatformException(code: "500", message: parsed['message']);
      }

      throw PlatformException(code: "201", message: "Error /register");
    } on PlatformException catch (e) {
      Dialogs.alert(context, title: "ERROR", message: e.message);
      return false;
    }
  }

  Future<bool> login(BuildContext context,
      {@required String email, @required String password}) async {
    try {
      final url = "${AppConfig.apiHost}/auth/login";

      final response =
          await http.post(url, body: {"email": email, "password": password});

      final parsed = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final token = parsed['accessToken'] as String;
        final expiresIn = parsed['expiresIn'] as int;
        await _session.set(token, expiresIn);
        return true;
      } else if (response.statusCode == 401) {
        throw PlatformException(code: "401", message: parsed['message']);
      }
      throw PlatformException(code: "500", message: "Error /login");
    } on PlatformException catch (e) {
      Dialogs.alert(context, title: "ERROR", message: e.message);
      return false;
    }
  }

  Future<dynamic> _refreshToken(String expiredToken) async {
    try {
      final url = "${AppConfig.apiHost}/auth/refresh";

      final response = await http.put(url, headers: {"authorization": 'Bearer $expiredToken'});

      final parsed = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return parsed;
      } else if (response.statusCode == 401) {
        throw PlatformException(code: "500", message: parsed['message']);
      }

      throw PlatformException(code: "500", message: "Error /tokens/refresh");
    } on PlatformException catch (_) {
      return null;
    }
  }

  Future<String> getAccessToken() async {
    try {
      final result = await _session.get();
      if (result != null) {
        final token = result['token'] as String;
        final expiresIn = result['expiresIn'] as int;
        final createdAt = DateTime.parse(result['createdAt']);
        final currentDate = DateTime.now();

        final diff = currentDate.difference(createdAt).inSeconds;
        if (expiresIn - diff >= 60) {
          return token;
        }

        // refresh

        final newData = await _refreshToken(token);
        if (newData != null) {
          final newToken = newData['token'];
          final newExpiresIn = newData['expiresIn'];
          await _session.set(newToken, newExpiresIn);
          return newToken;
        }
        return null;
      }
      return null;
    } on PlatformException catch (_) {
      return null;
    }
  }
}
