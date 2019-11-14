import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ignite/views/loading_screen.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthResult result;

  Future<String> _authUser(LoginData login) async {
    try {
      result = await _auth.signInWithEmailAndPassword(
          email: login.name, password: login.password);
    } catch (e) {
      switch (e.code) {
        case 'ERROR_USER_NOT_FOUND':
          return 'Email non corretta';
        case 'ERROR_WRONG_PASSWORD':
          return 'Password non corretta';
      }
    }
    return null;
  }

  Future<String> _newUser(LoginData login) async {
    try {
      result = await _auth.createUserWithEmailAndPassword(
          email: login.name, password: login.password);
    } catch (e) {
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          return 'Email non valida';
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          return 'Email già utilizzata';
      }
      return e.message;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.red[600],
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: Colors.red[600],
    ));
    return FlutterLogin(
      title: 'Ignite',
      logo: 'assets/images/logo.png',
      messages: LoginMessages(
        usernameHint: 'Email',
        passwordHint: 'Password',
        confirmPasswordHint: 'Conferma la password',
        loginButton: 'LOG IN',
        signupButton: 'REGISTRATI',
        forgotPasswordButton: 'Password dimenticata?',
        recoverPasswordButton: 'AIUTO',
        goBackButton: 'INDIETRO',
        confirmPasswordError: 'Le due password inserite non corrispondono!',
        recoverPasswordDescription: 'Procedura per il recupero della password',
        recoverPasswordSuccess: 'Password recuperata con successo',
      ),
      onLogin: _authUser,
      onSignup: _newUser,
      onSubmitAnimationCompleted: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return LoadingScreen();
        }));
      },
    );
  }
}
