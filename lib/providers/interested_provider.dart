import 'package:flutter/cupertino.dart';
import 'package:fluttersecretchat/models/pet.dart';

class InterestedProvider with ChangeNotifier {
  List<Pet> _interested = [];

  void addInterested(Pet pet) {
    _interested.insert(0, pet);
    notifyListeners();
  }

  void removeInterested(int id) {
    _interested.removeWhere((user) => user.id == id);
    notifyListeners();
  }

  List<Pet> get interested => [..._interested];
}
