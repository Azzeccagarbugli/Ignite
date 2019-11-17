import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AppState extends ChangeNotifier {
  AppState() {
    appTheme = _darkTheme();
    loadStyle();
  }
  FirebaseUser currentUser;
  ThemeData appTheme;
  bool _isDark;
  String mapStyle;

  ThemeData _mainTheme() {
    _isDark = false;
    return ThemeData(
      primaryColor: Colors.red[600],
      accentColor: Colors.grey[500],
      bottomAppBarColor: Colors.red[600],
      buttonColor: Colors.grey[100],
      fontFamily: 'Nunito',
    );
  }

  ThemeData _darkTheme() {
    _isDark = true;
    return ThemeData(
      primaryColor: Colors.grey[900],
      accentColor: Colors.grey[700],
      bottomAppBarColor: Colors.grey[800],
      buttonColor: Colors.grey[100],
      fontFamily: 'Nunito',
    );
  }

  ThemeData getTheme() {
    return appTheme;
  }

  void loadStyle() {
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
  }

  String getMapStyle() {
    loadStyle();
    return mapStyle;
  }
}
