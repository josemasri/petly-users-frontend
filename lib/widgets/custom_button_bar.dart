import 'package:flutter/material.dart';
import 'package:fluttersecretchat/models/pet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomButtonBar extends StatelessWidget {
  final Pet pet;
  final bool detailRoute;
  final void Function(Pet pet) onAccept;
  final void Function(Pet pet) onReject;

  const CustomButtonBar({
    Key key,
    @required this.onAccept,
    @required this.onReject,
    @required this.pet,
    this.detailRoute = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 500,
      child: detailRoute
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _CustomIconButton(
                  size: 35,
                  onTap: onReject,
                  pet: pet,
                  color: Colors.red,
                  icon: FontAwesomeIcons.times,
                ),
                _CustomIconButton(
                  size: 35,
                  onTap: onAccept,
                  pet: pet,
                  color: Color(0xff00ff94),
                  icon: FontAwesomeIcons.solidHeart,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _CustomIconButton(
                  onTap: onReject,
                  pet: pet,
                  color: Colors.red,
                  icon: FontAwesomeIcons.times,
                ),
                _CustomIconButton(
                  onTap: onAccept,
                  pet: pet,
                  color: Color(0xff00ff94),
                  icon: FontAwesomeIcons.solidHeart,
                ),
                _CustomIconButton(
                  onTap: (pet) {
                    Navigator.pushNamed(
                      context,
                      'pet-details',
                      arguments: pet,
                    );
                  },
                  pet: pet,
                  color: Colors.orange,
                  icon: FontAwesomeIcons.dog,
                ),
              ],
            ),
    );
  }
}

class _CustomIconButton extends StatelessWidget {
  const _CustomIconButton({
    Key key,
    @required this.onTap,
    @required this.pet,
    this.color = Colors.red,
    this.icon = FontAwesomeIcons.times,
    this.size = 28,
  }) : super(key: key);

  final void Function(Pet pet) onTap;
  final Pet pet;
  final Color color;
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        iconSize: size,
        padding: (size == 28)
            ? const EdgeInsets.all(8.0)
            : const EdgeInsets.all(14.0),
        icon: FaIcon(
          icon,
        ),
        onPressed: () {
          onTap(pet);
        },
        color: color,
      ),
    );
  }
}
