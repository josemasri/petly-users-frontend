import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fluttersecretchat/providers/top_bar_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:fluttersecretchat/providers/interested_provider.dart';

class CustomTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _interestedProvider = Provider.of<InterestedProvider>(context);
    final active = Provider.of<TopBarProvider>(context).currentRoute;
    final _topBarProvider = Provider.of<TopBarProvider>(context);
    return Container(
      width: 390,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.person,
              color: (active == 0) ? Colors.orange : Colors.grey,
            ),
            onPressed: () {
              if (_topBarProvider.currentRoute != 0) {
                _topBarProvider.currentRoute = 0;
                Navigator.pushNamedAndRemoveUntil(
                    context, 'home', (_) => false);
              }
            },
          ),
          IconButton(
            icon: Icon(
              Icons.add_circle,
              color: (active == 1) ? Colors.orange : Colors.grey,
            ),
            onPressed: () {
              if (_topBarProvider.currentRoute != 1) {
                _topBarProvider.currentRoute = 1;
                Navigator.pushNamedAndRemoveUntil(
                    context, 'add-pet', (_) => false);
              }
            },
          ),
          IconButton(
            icon: Icon(
              FontAwesomeIcons.home,
              color: (active == 2) ? Colors.orange : Colors.grey,
            ),
            onPressed: () {
              if (_topBarProvider.currentRoute != 2) {
                _topBarProvider.currentRoute = 2;
                Navigator.pushNamedAndRemoveUntil(
                    context, 'home', (_) => false);
              }
            },
          ),
          Badge(
            showBadge: _interestedProvider.interested.length > 0,
            animationDuration: Duration(seconds: 2),
            badgeColor: Colors.orange,
            badgeContent: Text(
              _interestedProvider.interested.length.toString(),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            child: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.solidPaperPlane,
                color: (active == 3) ? Colors.orange : Colors.grey,
              ),
              onPressed: () {
                if (_topBarProvider.currentRoute != 3) {
                  _topBarProvider.currentRoute = 3;
                  Navigator.of(context).pushNamed('interested');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
