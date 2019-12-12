import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:ignite/providers/auth_provider.dart';
import 'package:ignite/providers/db_provider.dart';
import 'package:theme_provider/theme_provider.dart';
import '../main.dart';
import 'package:ignite/views/citizen_screen_views/citizen_screen.dart';
import 'package:provider/provider.dart';

import 'fireman_screen_views/fireman_screen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  LatLng _curloc;
  String _mapStyle;
  bool _isFireman;
  String _userMail;
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
    return SplashScreen.navigate(
      next: (context) => screenChange(),
      name: 'assets/general/intro.flr',
      backgroundColor: ThemeProvider.themeOf(context).data.primaryColor,
      loopAnimation: '1',
      until: () => this._untilFunction(),
      endAnimation: '1',
    );
  }

  StatefulWidget screenChange() {
    if (_isFireman) {
      return FiremanScreen(
        position: this._curloc,
        jsonStyle: this._mapStyle,
        userMail: this._userMail,
      );
    } else {
      return CitizenScreen(
        position: this._curloc,
        jsonStyle: this._mapStyle,
        userMail: this._userMail,
      );
    }
  }

  Future _untilFunction() async {
    await this._getIsFireman();
    await this._getPosition();
    await this._loadJson();
    await this._getUserMail();
  }

  void _getUserMail() async {
    String mail = await Provider.of<AuthProvider>(context).getUserMail();
    setState(() {
      _userMail = mail;
    });
  }

  void _getIsFireman() async {
    FirebaseUser user = await Provider.of<AuthProvider>(context).getUser();
    bool value =
        await Provider.of<DbProvider>(context).isCurrentUserFireman(user);
    setState(() {
      _isFireman = value;
    });
  }

  void _getPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _curloc = LatLng(position.latitude, position.longitude);
    });
  }

  void _loadJson() async {
    await rootBundle
        .loadString(
            'assets/general/${ThemeProvider.optionsOf<CustomOptions>(context).filename}.json')
        .then((string) {
      _mapStyle = string;
    });
  }
}
