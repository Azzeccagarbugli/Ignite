import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ignite/models/user.dart';
import 'package:theme_provider/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/services_provider.dart';
import 'citizen_screen_views/citizen_screen.dart';
import 'fireman_screen_views/fireman_screen.dart';
import 'introduction_tutorial.dart';
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
    String userMail = await AuthProvider().getUserMail();
    User user =
        await ServicesProvider().getUsersServices().getUserByMail(userMail);
    _isFireman = await ServicesProvider()
        .getUsersServices()
        .isUserFiremanById(user.getId());
    print(
        "L\'utente $userMail - id: ${user.getId()} - è un pompiere: $_isFireman");
  }

  Future _getIsFirstAccess() async {
    String userMail = await AuthProvider().getUserMail();
    User user =
        await ServicesProvider().getUsersServices().getUserByMail(userMail);
    _isFirstAccess = await ServicesProvider()
        .getUsersServices()
        .isUserFirstAccessById(user.getId());
    print(
        "L\'utente $userMail - id: ${user.getId()} - è al primo accesso: $_isFirstAccess");
  }
}
