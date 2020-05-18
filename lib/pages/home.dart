import 'package:flutter/material.dart';
import 'package:fluttersecretchat/providers/interested_provider.dart';
import 'package:fluttersecretchat/widgets/custom_top_bar.dart';
import 'package:provider/provider.dart';

import 'package:fluttersecretchat/providers/pets_provider.dart';
import 'package:fluttersecretchat/widgets/pet-cards.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final petsProvider = Provider.of<PetsProvider>(context);
    final interestedProvider = Provider.of<InterestedProvider>(context);   

    final petCards = petsProvider.pets.map((pet) {
      return CustomCard(
        pet: pet,
        onAccept: (pet) {
          interestedProvider.addInterested(pet);
          petsProvider.removePet(pet.id);
        },
        onReject: (pet) {
          petsProvider.removePet(pet.id);
        },
      );
    }).toList();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CustomTopBar(),
            Container(
              child: PetCards(
                cards: petCards,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
