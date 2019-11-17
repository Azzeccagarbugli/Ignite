import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppState extends ChangeNotifier {
  FirebaseUser currentUser;
  String mapStyle;

  ThemeData mainTheme() {
    return ThemeData(
      primaryColor: Colors.red[600],
      accentColor: Colors.grey[500],
      bottomAppBarColor: Colors.red[600],
      buttonColor: Colors.white,
      fontFamily: 'Nunito',
    );
  }

  ThemeData darkTheme() {
    return ThemeData(
      primaryColor: Colors.grey[900],
      accentColor: Colors.grey[700],
      bottomAppBarColor: Colors.grey[900],
      buttonColor: Colors.white,
      fontFamily: 'Nunito',
    );
  }

  /*void loadStyle() {
    if (_isDark) {
      rootBundle
          .loadString('assets/general/map_style_dark.json')
          .then((string) {
        mapStyle = string;
      });
    } else {
      rootBundle
          .loadString('assets/general/map_style_main.json')
          .then((string) {
        mapStyle = string;
      });
    }
  }

  void toggleTheme() {
    appTheme = _isDark ? _mainTheme() : _darkTheme();
    loadStyle();
    notifyListeners();
  }*/

  String getMapStyle() {
    return mapStyle;
  }
}
