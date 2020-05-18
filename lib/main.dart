import 'package:flutter/material.dart';
import 'package:fluttersecretchat/pages/add_pet.dart';
import 'package:fluttersecretchat/pages/interested.dart';
import 'package:fluttersecretchat/pages/pet_details.dart';
import 'package:fluttersecretchat/providers/interested_provider.dart';
import 'package:fluttersecretchat/providers/pets_provider.dart';
import 'package:fluttersecretchat/providers/top_bar_provider.dart';
import 'package:provider/provider.dart';

import 'package:fluttersecretchat/pages/chat.dart';
import 'package:fluttersecretchat/pages/home.dart';

import 'pages/login.dart';
import 'pages/sign_up.dart';
import 'pages/splash.dart';
import 'providers/me.dart';
import 'providers/chat_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Me(),
        ),
        ChangeNotifierProvider.value(
          value: ChatProvider(),
        ),
        ChangeNotifierProvider.value(
          value: PetsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: InterestedProvider(),
        ),
        ChangeNotifierProvider.value(
          value: TopBarProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Petly',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.orange,
        ),
        initialRoute: 'splash',
        routes: {
          'splash': (context) => SplashPage(),
          'login': (context) => LoginPage(),
          'singup': (context) => SingUpPage(),
          'home': (context) => HomePage(),
          'chat': (context) => ChatPage(),
          'pet-details': (context) => PetDetailsPage(),
          'interested': (context) => InterestedPage(),
          'add-pet': (context) => AddPetPage(),
        },
      ),
    );
  }
}

