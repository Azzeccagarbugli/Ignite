import 'package:flutter/material.dart';
import 'package:ignite/providers/auth_provider.dart';
import 'package:ignite/providers/db_provider.dart';
import 'package:ignite/views/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

void main() {
  runApp(Ignite());
}

class Ignite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          builder: (context) => DbProvider(),
        ),
      ],
      child: App(),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: [
        AppTheme(
          id: "main",
          description: "Tema principale",
          data: ThemeData(
            primaryColor: Colors.red[600],
            accentColor: Colors.grey[200],
            backgroundColor: Colors.white,
            bottomAppBarColor: Colors.red[600],
            buttonColor: Colors.white,
            fontFamily: 'Nunito',
          ),
          options: CustomOptions(
            filename: 'map_style_main',
            brightness: Brightness.dark,
          ),
        ),
        AppTheme(
          id: "dark",
          description: "Tema scuro",
          data: ThemeData(
            primaryColor: Colors.black,
            accentColor: Colors.grey[700],
            backgroundColor: Colors.grey[400],
            bottomAppBarColor: Colors.black,
            buttonColor: Colors.white,
            fontFamily: 'Nunito',
          ),
          options: CustomOptions(
            filename: 'map_style_dark',
            brightness: Brightness.light,
          ),
        ),
      ],
      child: ThemeConsumer(
        child: MaterialApp(
          theme: ThemeData(
            fontFamily: 'Nunito',
          ),
          home: LoginScreen(),
        ),
      ),
    );
  }
}

class CustomOptions implements AppThemeOptions {
  final String filename;
  final Brightness brightness;
  CustomOptions({
    @required this.filename,
    @required this.brightness,
  });
}
