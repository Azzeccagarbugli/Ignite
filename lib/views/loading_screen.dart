import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:ignite/models/app_state.dart';
import 'package:theme_provider/theme_provider.dart';
import '../main.dart';
import 'fireman_screen.dart';
import 'citizen_screen.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  LatLng _curloc;
  String _mapStyle;
  bool _isFireman;

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
    return MaterialApp(
      home: SplashScreen.navigate(
        next: (context) => screenChange(),
        name: 'assets/general/intro.flr',
        backgroundColor: ThemeProvider.themeOf(context).data.primaryColor,
        loopAnimation: '1',
        until: () => this._untilFunction(),
        endAnimation: '1',
      ),
    );
  }

  StatefulWidget screenChange() {
    if (_isFireman) {
      return FiremanScreen(
        position: this._curloc,
        jsonStyle: this._mapStyle,
      );
    } else {
      return CitizenScreen(
        position: this._curloc,
        jsonStyle: this._mapStyle,
      );
    }
  }

  Future _untilFunction() async {
    await this._getIsFireman();
    await this._getPosition();
    await this._loadJson();
  }

  Future<bool> _getIsFireman() async {
    _isFireman = await Provider.of<AppState>(context).isCurrentUserFireman();
    return _isFireman;
  }

  Future<dynamic> _getPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _curloc = LatLng(position.latitude, position.longitude);
    });
  }

  Future<dynamic> _loadJson() async {
    await rootBundle
        .loadString(
            'assets/general/${ThemeProvider.optionsOf<CustomOptions>(context).filename}.json')
        .then((string) {
      _mapStyle = string;
    });
  }
}
