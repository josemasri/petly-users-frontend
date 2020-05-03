import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fluttersecretchat/models/pet.dart';

import 'custom_button_bar.dart';
import 'custom_card_item.dart';

class PetCards extends StatelessWidget {
  final List<CustomCard> cards;

  const PetCards({Key key, @required this.cards}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 690,
          child: Stack(
            alignment: Alignment.center,
            children: cards,
          ),
        ),
      ],
    );
  }
}

class CustomCard extends StatefulWidget {
  final double marginTop;
  final Pet pet;
  final void Function(Pet pet) onAccept;
  final void Function(Pet pet) onReject;

  const CustomCard({
    Key key,
    this.marginTop = 0,
    @required this.pet,
    @required this.onAccept,
    @required this.onReject,
  }) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool start = false;
  double startPosition = 0;
  double acceptOpacity = 0;
  double denyOpacity = 0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.marginTop,
      child: SlideInRight(
        child: FadeOutLeft(
          duration: Duration(seconds: 2),
          child: Container(
            height: 670,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          'pet-details',
                          arguments: widget.pet,
                        );
                      },
                      child: Listener(
                        onPointerMove: _customOnPoinerMove,
                        child: Draggable(
                          onDragStarted: () {
                            setState(() {
                              start = true;
                            });
                          },
                          onDragEnd: (drag) {
                            if (drag.offset.dx < -120) {
                              // Make some action
                              widget.onAccept(widget.pet);
                            } else if (drag.offset.dx > 120) {
                              // Make other action
                              widget.onReject(widget.pet);
                            }
                          },
                          childWhenDragging: Container(),
                          feedback: Stack(
                            children: <Widget>[
                              CustomCardItem(
                                pet: widget.pet,
                              ),
                              Positioned(
                                left: 10,
                                top: 60,
                                child: FadeIn(
                                  child: Transform.rotate(
                                    angle: -0.5,
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.green
                                                .withOpacity(acceptOpacity),
                                            width: 10,
                                          ),
                                        ),
                                        child: Text(
                                          'Adopt',
                                          style: TextStyle(
                                            color: Colors.green
                                                .withOpacity(acceptOpacity),
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 10,
                                top: 60,
                                child: Transform.rotate(
                                  angle: 0.5,
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.red
                                              .withOpacity(denyOpacity),
                                          width: 10,
                                        ),
                                      ),
                                      child: Text(
                                        'Nope',
                                        style: TextStyle(
                                          color: Colors.red
                                              .withOpacity(denyOpacity),
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          child: CustomCardItem(pet: widget.pet),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: -50,
                  child: CustomButtonBar(
                    pet: widget.pet,
                    onAccept: widget.onAccept,
                    onReject: widget.onReject,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _customOnPoinerMove(PointerMoveEvent pointerMoveEvent) {
    final currentPosition = pointerMoveEvent.position.dx;
    if (start) {
      setState(() {
        start = false;
        startPosition = currentPosition;
      });
    }
    if (startPosition < currentPosition) {
      // Adopt
      setState(() {
        denyOpacity = 0;
        acceptOpacity = min((currentPosition - startPosition) / 300, 1);
      });
    } else {
      // Nope
      setState(() {
        acceptOpacity = 0;
        denyOpacity = min((startPosition - currentPosition) / 300, 1);
      });
    }
  }
}
