import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttersecretchat/api/pets_api.dart';
import 'package:fluttersecretchat/providers/pets_provider.dart';
import 'package:fluttersecretchat/utils/jwt.dart';
import 'package:provider/provider.dart';
import '../api/auth_api.dart';
import '../models/user.dart';
import '../providers/me.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _authAPI = AuthAPI();

  Me _me;

  @override
  void initState() {
    super.initState();

    this.check();
  }

  check() async {
    final token = await _authAPI.getAccessToken();
    final petsProvider = Provider.of<PetsProvider>(context, listen: false);
    print(token);

    if (token != null) {
      final user = parseJwt(token);
      _me.data = User.fromJson(user);
      _me.token = token;
      final res = await PetsApi.getPets(context: context, token: token);
      petsProvider.addPets(res.pets);
      Navigator.pushReplacementNamed(context, "home");
    } else {
      Navigator.pushReplacementNamed(context, "login");
    }
  }

  @override
  Widget build(BuildContext context) {
    _me = Me.of(context);

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.orange,
        ),
      ),
    );
  }
}
