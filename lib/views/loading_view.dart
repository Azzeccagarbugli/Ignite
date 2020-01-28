import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ignite/providers/auth_provider.dart';
import 'package:ignite/providers/db_provider.dart';
import 'package:ignite/views/introduction_tutorial.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:ignite/views/citizen_screen_views/citizen_screen.dart';
import 'package:provider/provider.dart';
import 'fireman_screen_views/fireman_screen.dart';
import 'loading_screen.dart';

class LoadingView extends StatefulWidget {
  @override
  _LoadingViewState createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  bool _isFireman;
  bool _isFirstAccess;
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
    return FutureBuilder(
      future: this._untilFunction(),
      builder: (context, data) {
        switch (data.connectionState) {
          case ConnectionState.none:
            return new LoadingScreen(
              message: "Accesso in corso",
              pathFlare: "assets/general/user.flr",
              nameAnimation: "smile",
            );
          case ConnectionState.active:
          case ConnectionState.waiting:
            return new LoadingScreen(
              message: "Accesso in corso",
              pathFlare: "assets/general/user.flr",
              nameAnimation: "smile",
            );
          case ConnectionState.done:
            return this.screenChange();
        }
        return null;
      },
    );
  }

  Widget screenChange() {
    if (_isFirstAccess) {
      return IntroductionTutorial(
        isFireman: this._isFireman,
      );
    } else if (_isFireman) {
      return FiremanScreen();
    } else {
      return CitizenScreen();
    }
  }

  Future _untilFunction() async {
    await Future.wait([
      this._getIsFireman(),
      this._getIsFirstAccess(),
    ]);
  }

  Future _getIsFireman() async {
    FirebaseUser user = await Provider.of<AuthProvider>(context).getUser();
    _isFireman = await DbProvider().isCurrentUserFireman(user);
    print("L\'utente ${user.email} è un pompiere: ${_isFireman}");
  }

  Future _getIsFirstAccess() async {
    FirebaseUser user = await Provider.of<AuthProvider>(context).getUser();
    _isFirstAccess = await DbProvider().isFirstAccess(user);
    print("L\'utente ${user.email} è al primo accesso: ${_isFirstAccess}");
  }
}
