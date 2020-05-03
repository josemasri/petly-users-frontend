import 'package:flutter/material.dart';
import 'owner.dart';

class Pet {
  final int id, age;
  final String name, description, animal, image;
  final Owner owner;

  Pet({
    @required this.id,
    @required this.animal,
    @required this.name,
    @required this.age,
    @required this.image,
    @required this.description,
    @required this.owner,
  });
}
