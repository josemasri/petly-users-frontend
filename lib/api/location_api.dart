import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import '../app_config.dart';

class LocationAPI {
  static Future<dynamic> getLocation({
    @required BuildContext context,
    @required LocationData locationData,
    int zoom = 8,
  }) async {
    try {
      final url = Uri.https(AppConfig.apiLocationUrl, 'reverse', {
        'format': 'jsonv2',
        'zoom': zoom.toString(),
        'lat': locationData.latitude.toString(),
        'lon': locationData.longitude.toString()
      });

      final response = await http.get(url);
      final parsed = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return parsed;
      }
      throw PlatformException(code: "201", message: "error: /user-info");
    } catch (e) {
      return null;
    }
  }
}
