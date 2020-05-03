import 'package:flutter/material.dart';

class Owner {
  final int id;
  final String name, email, country, city;

  Owner({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.city,
    @required this.country,
  });
}
