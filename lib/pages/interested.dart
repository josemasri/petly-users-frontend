import 'package:flutter/material.dart';
import 'package:fluttersecretchat/providers/interested_provider.dart';
import 'package:fluttersecretchat/widgets/custom_top_bar.dart';
import 'package:provider/provider.dart';

class InterestedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final interestedProvider = Provider.of<InterestedProvider>(context);
    final pets = Provider.of<InterestedProvider>(context).interested;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomTopBar(),
            Container(
              margin: EdgeInsets.only(left: 8),
              child: Text(
                'Mensajes',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 500,
              child: ListView.builder(
                itemCount: interestedProvider.interested.length,
                itemBuilder: (BuildContext context, int index) {
                  final pet = pets[index];
                  return Column(
                    children: <Widget>[
                      Dismissible(
                        background: Container(
                          color: Colors.red,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(pet.imageUrl),
                          ),
                          title: Text(pet.name),
                          subtitle: Text(pet.userCounty),
                          trailing: Text(
                            'Dueño: ${pet.name}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed('chat');
                          },
                        ),
                        key: Key(pet.id.toString()),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
