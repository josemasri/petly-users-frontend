import 'package:flutter/material.dart';
import 'package:fluttersecretchat/models/pet.dart';
import 'package:fluttersecretchat/providers/interested_provider.dart';
import 'package:fluttersecretchat/providers/pets_provider.dart';
import 'package:fluttersecretchat/widgets/custom_button_bar.dart';
import 'package:fluttersecretchat/widgets/custom_card_item.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PetDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pet pet = ModalRoute.of(context).settings.arguments;
    final interestedProvider = Provider.of<InterestedProvider>(context);
    final petsProvider = Provider.of<PetsProvider>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                CustomCardItem(
                  pet: pet,
                  detailsPage: true,
                ),
                Container(
                  width: double.infinity,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Text(
                              '${pet.name},',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              pet.age.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        _PetAttribute(
                          value: pet.animal,
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 0.5,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        SizedBox(height: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 100),
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Text(
                                  pet.description,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.justify,
                                  maxLines: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                         Container(
                          width: double.infinity,
                          height: 0.5,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Dueño',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        SizedBox(height: 5),
                        _PetAttribute(
                          icon: FontAwesomeIcons.userTie,
                          value: pet.userFirstName,
                        ),
                        SizedBox(height: 5),
                        _PetAttribute(
                          icon: FontAwesomeIcons.building,
                          value: pet.userCounty,
                        ),
                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: -50,
            child: CustomButtonBar(
              onAccept: (pet) {
                interestedProvider.addInterested(pet);
                petsProvider.removePet(pet.id);
                Navigator.of(context).pop();
              },
              onReject: (pet) {
                petsProvider.removePet(pet.id);
                Navigator.of(context).pop();
              },
              pet: pet,
              detailRoute: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _PetAttribute extends StatelessWidget {
  final String value;
  final IconData icon;

  const _PetAttribute({
    Key key,
    @required this.value,
    this.icon = FontAwesomeIcons.dog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FaIcon(icon, size: 12, color: Colors.grey,),
        SizedBox(width: 10),
        Text(
          value,
          style: TextStyle( fontWeight: FontWeight.w300, fontSize: 12),
        ),
      ],
    );
  }
}
