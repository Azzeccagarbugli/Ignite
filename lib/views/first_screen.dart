import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ignite/views/loading_screen.dart';

class FirstScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> _authUser(LoginData login) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: login.name, password: login.password);
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Ignite',
      onLogin: _authUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoadingScreen(),
        ));
      },
    );
  }
}
