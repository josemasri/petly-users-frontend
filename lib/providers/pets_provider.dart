import 'package:flutter/material.dart';
import 'package:fluttersecretchat/models/owner.dart';
import 'package:fluttersecretchat/models/pet.dart';

class PetsProvider with ChangeNotifier {
  List<Pet> _pets = [
    Pet(
      id: 1,
      age: 5,
      animal: 'Perro',
      description: 'Officia eu laboris esse irure mollit nulla aliquip. Aliquip incididunt quis labore ad pariatur laboris culpa. Lorem enim cillum est quis nisi sit quis aliquip occaecat incididunt nisi minim deserunt. Irure cupidatat commodo aute eiusmod tempor velit ad incididunt. Ad tempor dolore pariatur proident cupidatat ex id.',
      image: 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Siberian_Husky_blue_eyes_Flickr.jpg',
      name: 'Poncho',
      owner: Owner(
        id: 1,
        name: 'Jose',
        email: 'josemasri@mail.com',
        city: 'CDMX',
        country: 'México',
      ),
    )
  ];

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
