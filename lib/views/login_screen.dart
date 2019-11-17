import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ignite/models/app_state.dart';
import 'package:ignite/widgets/anonimous_button.dart';
import 'package:ignite/widgets/fab_first_screen.dart';
import 'package:ignite/widgets/faq_button.dart';
import 'package:ignite/views/loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
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
      systemNavigationBarColor:
          ThemeProvider.themeOf(context).data.primaryColor,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor:
          ThemeProvider.themeOf(context).data.primaryColor,
    ));

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      extendBody: true,
      body: Stack(
        children: <Widget>[
          FlutterLogin(
            theme: LoginTheme(
              primaryColor: ThemeProvider.themeOf(context).data.primaryColor,
              accentColor: ThemeProvider.themeOf(context).data.accentColor,
              titleStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            title: 'Ignite',
            logo: 'assets/images/logo.png',
            onRecoverPassword: _recoverPassword,
            messages: buildLoginMessages(),
            onLogin: _authUser,
            onSignup: _newUser,
            onSubmitAnimationCompleted: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return LoadingScreen();
              }));
            },
          ),
          FaqButton(
            animation: animation,
            align: Alignment.bottomLeft,
          ),
          AnonimousButton(
            animation: animation,
            anonimousFunction: _signInAnonymously(),
            align: Alignment.bottomRight,
          ),
          ThemeButton(
            align: Alignment.bottomCenter,
            animation: animation,
          ),
        ],
      ),
    );
  }

  LoginMessages buildLoginMessages() {
    return LoginMessages(
      usernameHint: 'Email',
      passwordHint: 'Password',
      confirmPasswordHint: 'Conferma la password',
      loginButton: 'LOGIN',
      signupButton: 'REGISTRATI',
      forgotPasswordButton: 'Password dimenticata?',
      recoverPasswordButton: 'RECUPERA',
      goBackButton: 'INDIETRO',
      confirmPasswordError: 'Le due password inserite non corrispondono!',
      recoverPasswordDescription: 'Procedura per il recupero della password',
      recoverPasswordSuccess: 'Password recuperata con successo',
    );
  }
}

class ThemeButton extends StatelessWidget {
  final Animation<double> animation;
  final Alignment align;
  ThemeButton({@required this.animation, @required this.align});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: FabLoginScreen(
        alignment: align,
        heroTag: 'button',
        icon: Icon(
          Icons.autorenew,
          color: ThemeProvider.themeOf(context).data.primaryColor,
        ),
        onPressed: () {
          ThemeProvider.controllerOf(context).nextTheme();
        },
      ),
    );
  }
}
