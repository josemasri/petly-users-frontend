import 'package:flutter/material.dart';

class TopBarProvider with ChangeNotifier {
  int _currentRoute = 2;

  int get currentRoute => _currentRoute;

  set currentRoute(int value) {
    _currentRoute = value;
    notifyListeners();
  }
}
