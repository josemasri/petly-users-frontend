import 'package:flutter/material.dart';
import 'package:fluttersecretchat/models/pet.dart';

class PetsProvider with ChangeNotifier {
  List<Pet> _pets = [];

  List<Pet> get pets => _pets;

  void addPets(List<Pet> pets) {
    _pets.addAll(pets);
    notifyListeners();
  }

  void removePet(int id) {
    _pets.removeWhere((user) => user.id == id);
    notifyListeners();
  }
}
