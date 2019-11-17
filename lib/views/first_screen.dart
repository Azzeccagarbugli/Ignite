import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ignite/views/faq.dart';
import 'package:ignite/views/introduction_tutorial.dart';
import 'package:ignite/views/loading_screen.dart';
import 'package:ignite/widgets/fab_first_screen.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen>
    with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthResult result;

  AnimationController controller;
  Animation<double> animation;

  int animationTime = 1200;

  @override
  initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(
        milliseconds: animationTime,
      ),
      vsync: this,
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<String> _authUser(LoginData login) async {
    try {
      result = await _auth.signInWithEmailAndPassword(
          email: login.name, password: login.password);
      controller.reverse();
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
      controller.reverse();
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

  Future<String> _recoverPassword(String currentEmail) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: currentEmail,
      );
    } catch (e) {
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          return 'Email non valida';
        case 'ERROR_USER_NOT_FOUND':
          return 'Email inesistente';
      }
      return e.message;
    }
    return null;
  }

  Future<void> _signInAnonymously() async {
    try {
      await _auth.signInAnonymously();
    } catch (e) {
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Theme.of(context).primaryColor,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: Theme.of(context).primaryColor,
    ));

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      extendBody: true,
      body: Stack(
        children: <Widget>[
          FlutterLogin(
            title: 'Ignite',
            logo: 'assets/images/logo.png',
            onRecoverPassword: _recoverPassword,
            messages: LoginMessages(
              usernameHint: 'Email',
              passwordHint: 'Password',
              confirmPasswordHint: 'Conferma la password',
              loginButton: 'LOGIN',
              signupButton: 'REGISTRATI',
              forgotPasswordButton: 'Password dimenticata?',
              recoverPasswordButton: 'RECUPERA',
              goBackButton: 'INDIETRO',
              confirmPasswordError:
                  'Le due password inserite non corrispondono!',
              recoverPasswordDescription:
                  'Procedura per il recupero della password',
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
          ),
          FadeTransition(
            opacity: animation,
            child: Hero(
              tag: 'icon_faq',
              child: FabLoginScreen(
                alignment: Alignment.bottomLeft,
                icon: Icon(
                  Icons.question_answer,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FaqScreen();
                  }));
                },
              ),
            ),
          ),
          FadeTransition(
            opacity: animation,
            child: FabLoginScreen(
              alignment: Alignment.bottomRight,
              heroTag: 'incognito_btn',
              icon: Icon(
                Icons.visibility_off,
              ),
              onPressed: () {
                _signInAnonymously();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return IntroductionTutorial();
                }));
              },
            ),
          ),
        ],
      ),
    );
  }
}
