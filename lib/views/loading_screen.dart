import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/services.dart';

import 'homepage.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  LatLng _curloc;
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
      systemNavigationBarColor: Theme.of(context).primaryColor,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: Theme.of(context).primaryColor,
    ));
    return MaterialApp(
      home: SplashScreen.navigate(
        name: 'assets/general/intro.flr',
        backgroundColor: Theme.of(context).primaryColor,
        next: (context) {
          return Homepage(position: this._curloc);
        },
        loopAnimation: '1',
        until: () => this.getPosition(),
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
}
