import 'dart:convert';

import 'package:fluttersecretchat/models/pet.dart';

PetRes petResFromJson(String str) => PetRes.fromJson(json.decode(str));

String petResToJson(PetRes data) => json.encode(data.toJson());

class PetRes {
    List<Pet> pets;

    PetRes({
        this.pets,
    });

    factory PetRes.fromJson(Map<String, dynamic> json) => PetRes(
        pets: List<Pet>.from(json["pets"].map((x) => Pet.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "pets": List<dynamic>.from(pets.map((x) => x.toJson())),
    };
}

