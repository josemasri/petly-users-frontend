import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'dialogs.dart';

class LocationUtils {
  static Future<LocationData> getLocation(BuildContext context) async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    while (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      Dialogs.alert(context,
          title: 'Please enable location',
          message: 'We your location to show animals near you');
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      while (_permissionGranted != PermissionStatus.granted) {
        Dialogs.alert(context,
            title: 'Please enable location',
            message: 'We your location to show animals near you');
      }
    }

    return await location.getLocation();
  }
}
