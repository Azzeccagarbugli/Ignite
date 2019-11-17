import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:ignite/models/app_state.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';
import '../main.dart';
import 'homepage.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  LatLng _curloc;
  String _mapStyle;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    printMail();
  }

  void printMail() async {
    FirebaseUser utente = await _auth.currentUser();
    if (utente != null) {
      print('${utente.email} - ');
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
    return MaterialApp(
      home: SplashScreen.navigate(
        next: (context) => Homepage(
          position: this._curloc,
          jsonStyle: this._mapStyle,
        ),
        name: 'assets/general/intro.flr',
        backgroundColor: ThemeProvider.themeOf(context).data.primaryColor,
        loopAnimation: '1',
        until: () {
          this.getPosition();
          this.loadJson();
        },
        endAnimation: '1',
      ),
    );
  }

  Future<dynamic> getPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _curloc = LatLng(position.latitude, position.longitude);
    });
  }

  Future<dynamic> loadJson() async {
    await rootBundle
        .loadString(
            'assets/general/${ThemeProvider.optionsOf<CustomMapStyle>(context).filename}.json')
        .then((string) {
      _mapStyle = string;
    });
  }
}
