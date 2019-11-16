import 'package:flutter/material.dart';

class Themes {
  static ThemeData mainTheme() {
    return ThemeData(
      primaryColor: Colors.red[600],
      accentColor: Colors.grey[500],
      fontFamily: 'Nunito',
    );
  }

  static ThemeData navyTheme() {
    return ThemeData(
      primaryColor: Colors.blue[600],
      accentColor: Colors.grey[700],
      fontFamily: 'Nunito',
    );
  }

  static ThemeData vaporTheme() {
    return ThemeData(
      primaryColor: Colors.pink[300],
      accentColor: Colors.orange[700],
      fontFamily: 'Nunito',
    );
  }
}
