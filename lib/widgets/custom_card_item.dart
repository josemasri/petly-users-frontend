import 'package:flutter/material.dart';
import 'package:fluttersecretchat/models/pet.dart';

class CustomCardItem extends StatelessWidget {
  final Pet pet;
  final bool detailsPage;

  const CustomCardItem({Key key, @required this.pet, this.detailsPage = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: 380,
          height: detailsPage ? 300 : 550,
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    placeholder: AssetImage('assets/img/loading.gif'),
                    image: NetworkImage(pet.imageUrl),
                  ),
                ),
              ),
              detailsPage
                  ? Container()
                  : Positioned(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        // width: 170,
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  pet.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  pet.age.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  pet.userCounty,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      bottom: 0,
                      left: 0,
                    ),
            ],
          ),
        ),
      ),
      tag: pet.id,
    );
  }
}
